import 'dart:async' show FutureOr;
import 'dart:io' show Platform, exit;

import 'package:args/command_runner.dart';
import 'package:dartbook/context.dart';
import 'package:dartbook/output.dart';
import 'package:path/path.dart' as p;
import 'package:shelf_static/shelf_static.dart' show createStaticHandler;
import 'package:shelf/shelf_io.dart' as io;
import 'package:watcher/watcher.dart' show DirectoryWatcher;

import 'diff.dart';

void main(List<String> args) {
  final runner = CommandRunner<int>('dartbook', "A dart implementation of gitbook");
  final parser = runner.argParser;
  parser.addFlag('verbose', abbr: 'v', help: 'Show additional diagnostic info');

  runner.addCommand(_BuildCommand());
  runner.addCommand(_ServeCommand());
  runner.addCommand(DiffCommand());
  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}

abstract class _MainCommand extends Command<int> {

  _MainCommand() {
    argParser.addOption('format', abbr: 'f', allowed: ['ebook', 'website'], defaultsTo: 'website',
        help: 'what kind of output to generate');
  }

  @override
  String get invocation => '${runner!.executableName} $name [<options>] [root] [output]';

  @override
  FutureOr<int> run() {
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
    _makeOutput(root, out, option);
    return 0;
  }

  Output _makeOutput(String rootDir, String outDir, Map<String, String> option) {
    final context = BookContext.assemble(
      root: rootDir,
      options: option,
    );
    final fmt = option['format'] ?? 'website';
    final output = Output.generate(context, Option(
      format: fmt,
      root: outDir,
    ));
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
  Output _makeOutput(String rootDir, String outDir, Map<String, String> option) {
    final output = super._makeOutput(rootDir, outDir, option);
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
