import 'dart:async' show FutureOr;
import 'dart:io' show Directory, File, Platform, Process, exit;

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:dartbook/cli/context.dart';
import 'package:dartbook/cli/io.dart' as io;
import 'package:dartbook/cli/output.dart';
import 'package:dartbook/cli/logger.dart';
import 'package:dartbook/cli/src/default.dart';
import 'package:dartbook/cli/utils.dart' as u;
import 'package:dartbook/cli/utils.dart';
import 'package:path/path.dart' as p;
import 'package:shelf_static/shelf_static.dart' show createStaticHandler;
import 'package:shelf/shelf_io.dart' as io;
import 'package:watcher/watcher.dart' show DirectoryWatcher;

import 'diff.dart';

void main(List<String> args) {
  // If using 'args' packages, `Command` would have to define many options which
  // already exist in git diff, so handle it separately.
  int pos = args.indexOf('diff');
  if (pos >= 0) {
    diffMain(args.sublist(pos + 1));
    return;
  }
  final runner = CommandRunner<int>('dartbook', "A dart implementation of gitbook");
  final parser = runner.argParser;
  parser.addFlag('verbose', abbr: 'v', help: 'Show additional diagnostic info');

  runner.addCommand(_InitCommand());
  runner.addCommand(_BuildCommand());
  runner.addCommand(_ServeCommand());
  runner.addCommand(_DiffCommand());
  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}

class _InitCommand extends Command<int> {

  _InitCommand() {
    argParser.addOption('languages', abbr: 'l',
        help: "specify multilingualism, separated by ',', e.g. fr,de,en."
    );
    argParser.addOption('deploy', abbr: 'p',
        help: "init with a ci config file on a specified host. separated by ',', e.g. github,gitlab",
    );
    argParser.addFlag('with-git', abbr: 'g', defaultsTo: true,
      help: "init with git repo creation.",
    );
  }

  @override
  String get name => 'init';

  @override
  String get description => 'setup and create files for a book';

  @override
  String get invocation => '${runner!.executableName} $name [options] [root]';

  @override
  FutureOr<int> run() async {
    final root = argResults?.rest.firstOrNull ?? '.';
    final languages = argResults?['languages']?.toString().split(',') ?? <String>[];
    if (languages.isEmpty) {
      _createEmptyBook(root);
    } else {
      for (final l in languages) {
        final path = p.join(root, l);
        _createEmptyBook(path);
      }
      _createMultilingual(root, languages);
    }
    final hosts = argResults?['deploy']?.toString().split(',') ?? <String>[];
    await _createDeployFile(root, hosts);
    if (argResults?['with-git'] ?? false) {
      await _createGitRepo(root);
    }
    return 0;
  }
}

const _deployPaths = {
  'gitlab': '.gitlab-ci.yml',
  'github': '.github/workflows/pages.yml',
};

final _logger = Logger(true);

Future<void> _createGitRepo(String root) async {
  final cur = Directory.current;
  Directory.current = root;
  try {
    await Process.run('git', ['init', '-b', 'main']);
    await Process.run('git', ['add', '.']);
    await Process.run('git', ['commit', '-m', 'book repo init']);
  } on Exception catch (e) {
    _logger.e("create git repo error: $e");
  }
  Directory.current = cur;
}

Future<void> _createDeployFile(String root, List<String> hosts) async {
  final paths = hosts.map((host) {
    final path = _deployPaths[host];
    if (path == null) {
      _logger.w("'$host' is not a supported deploy host! Valid values are [${_deployPaths.keys.join(', ')}]");
    }
    return path;
  }).whereNotNull();
  final resPath = await resolvePackageLocation('ci');
  for (final path in paths) {
    io.copyFileSync(p.join(resPath, path), p.join(root, path));
  }
}

void _createMultilingual(String path, List<String> languages) {
  _ensureDirectory(path);
  final readme = File(p.join(path, 'README.md'));
  if (!readme.existsSync()) {
    readme.writeAsStringSync(readmeDefault);
  }
  final langs = File(p.join(path, 'LANGS.md'));
  if (!langs.existsSync()) {
    langs.writeAsStringSync(multilingual(languages));
  }
}

void _createEmptyBook(String path) {
  _ensureDirectory(path);
  File(p.join(path, 'README.md')).writeAsStringSync(readmeDefault);
  File(p.join(path, 'SUMMARY.md')).writeAsStringSync(summaryDefault);
}

bool _ensureDirectory(String path) {
  final dir = Directory(path);
  var created = false;
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
    created = true;
  }
  return created;
}

abstract class _MainCommand extends Command<int> {

  _MainCommand() {
    argParser.addOption('format', abbr: 'f', allowed: ['ebook', 'website'], defaultsTo: 'website',
        help: 'what kind of output to generate');
  }

  @override
  String get invocation => '${runner!.executableName} $name [<options>] [root] [output]';

  @override
  FutureOr<int> run() async {
    final result = argResults;
    final rest = result?.rest ?? [];
    String root = '.';
    String out = '_book';
    if (rest.isEmpty) {
      root = p.normalize(p.absolute(root));
      out = p.normalize(p.absolute(out));
    } else if (rest.length == 1) {
      root = p.normalize(p.absolute(rest[0]));
      out = p.join(root, out);
    } else {
      root = p.normalize(p.absolute(rest[0]));
      out = p.normalize(p.absolute(rest[1]));
    }

    final global = globalResults;
    String? v;
    final option = <String, String>{
      for (final opt in (global?.options ?? <String>[]))
        if ((v = global?[opt]?.toString()) != null)
          opt: v!,
      for (final opt in (result?.options ?? <String>[]))
        if ((v = result?[opt]?.toString()) != null)
          opt: v!,
    };

    final assetRoot = await u.resolvePackageLocation('theme-res');
    _makeOutput(root, out, assetRoot, option);
    return 0;
  }

  Output _makeOutput(String rootDir, String outDir, String assetRoot, Map<String, String> option) {
    final at = DateTime.now().millisecondsSinceEpoch;
    final context = BookContext.assemble(
      root: rootDir,
      options: option,
    );
    final fmt = option['format'] ?? 'website';
    final output = Output.generate(context, Option(
      format: fmt,
      root: outDir,
      pkgAsset: assetRoot,
    ));
    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    print("build output cost ${d.inSeconds}.${mills}s.");
    return output;
  }
}

class _BuildCommand extends _MainCommand {

  @override
  final name = 'build';

  @override
  final description = 'Build a book in specified directory';
}

class _ServeCommand extends _MainCommand {
  @override
  final name = 'serve';

  @override
  final description = 'Serve the book as a website for testing';

  _ServeCommand() {
    argParser.addOption('port', abbr: 'p', help: 'Port for server to listen on');
    argParser.addFlag('watch', abbr: 'w', defaultsTo: true,
      help: 'Enable file watcher and live reloading',);
  }

  @override
  Output _makeOutput(String rootDir, String outDir, String assetRoot, Map<String, String> option) {
    final output = super._makeOutput(rootDir, outDir, assetRoot, option);
    final logger = output.context.logger;
    if (option['watch'] == "true") {
      print('Watch files at $rootDir ...');
      DirectoryWatcher(p.absolute(rootDir)).events.listen((e) {
        if (p.isWithin(outDir, e.path)) {
          return;
        }
        output.onFileChanged(e);
      }).onError((e) {
        final solution = Platform.isLinux ? """
sudo sysctl fs.inotify.max_user_watches=1048576
or
adding 'fs.inotify.max_user_watches=1048576' to '/etc/sysctl.conf'"""
            : '$e';
        logger.i("Watch directory failed:\n$solution");
      });
    }

    print('\nStarting server ...');
    final port = int.tryParse(option['port'] ?? '') ?? 4000;
    io.serve(
      createStaticHandler(outDir, defaultDocument: 'index.html'),
      'localhost',
      port,
    ).then((server) {
      print('Serving book on http://localhost:$port');
    });
    return output;
  }
}

// Just for showing usage info
class _DiffCommand extends Command<int> {
  @override
  final description = 'Show diff match patch but same options with git diff';

  @override
  String get name => 'diff';

}
