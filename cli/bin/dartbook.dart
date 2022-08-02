import  'package:dartbook/context.dart';
import 'package:dartbook/output.dart';
import 'package:path/path.dart' as p;
import 'package:shelf_static/shelf_static.dart' show createStaticHandler;
import 'package:shelf/shelf_io.dart' as io;
import 'package:watcher/watcher.dart' show DirectoryWatcher;

void main(List<String> args) {
  final options = {
    'format': 'website',
    'log': 'debug',
  };

  int len = args.length;
  final root = len > 0 ? args[0] : '.';
  final out = len > 1 ? args[1] : '_book';

  final rootDir = p.absolute(root);

  final context = BookContext.assemble(
    root: rootDir,
    options: options,
  );

  final fmt = options['format'] ?? 'website';
  final outDir = p.join(rootDir, out);
  final output = Output.generate(context, Option(
    format: fmt,
    root: outDir,
  ));

  print('Watch files at $rootDir ...');
  DirectoryWatcher(p.absolute(rootDir)).events.listen((e) {
    if (p.isWithin(outDir, e.path)) {
      return;
    }
    output.onFileChanged(e);
  });

  print('\nStarting server ...');
  final port = int.tryParse(options['port'] ?? '') ?? 4000;
  io.serve(
    createStaticHandler(outDir, defaultDocument: 'index.html'),
    'localhost',
    port,
  ).then((server) {
    print('Serving book on http://localhost:4000');
  });
}
