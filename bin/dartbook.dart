import 'dart:async' show FutureOr;
import 'dart:io' show Directory, File, Platform, exit;
import 'dart:isolate' show Isolate;

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:dartbook/cli/context.dart';
import 'package:dartbook/cli/output.dart';
import 'package:dartbook/cli/src/default.dart';
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


Future<String> _resolveAssetRoot() async {
  final uri = Uri.parse('package:dartbook/theme-res');
  final pkgUri = await Isolate.resolvePackageUri(uri);
  return pkgUri?.toFilePath() ?? '';
}

class _InitCommand extends Command<int> {

  _InitCommand() {
    argParser.addOption('languages', abbr: 'l',
        help: "specify multilingualism, separated by ',', e.g. fr,de,en."
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
    return 0;
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

    final assetRoot = await _resolveAssetRoot();
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
