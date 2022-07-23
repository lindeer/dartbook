import  'package:dartbook/context.dart';
import 'package:dartbook/output.dart';
import 'package:path/path.dart' as p;

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
  Output.generate(context, Option(
    format: fmt,
    root: p.join(rootDir, out),
  ));
}
