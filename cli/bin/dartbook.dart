import 'package:dartbook/assemble.dart';
import 'package:dartbook/generator.dart';
import 'package:dartbook/output.dart';
import 'package:dartbook/parser.dart';
import 'package:dartbook_models/logger.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  final options = {
    'format': 'website',
    'log': 'info',
  };

  int len = args.length;
  final root = len > 0 ? args[0] : '.';
  final out = len > 1 ? args[1] : '_book';

  final logger = Logger(options['log']);
  final parser = MarkdownParser(logger);

  final rootDir = p.absolute(root);
  final assembler = BookAssembler(logger: logger, parser: parser);

  final manager = assembler.assemble(rootDir);

  final fmt = options['format'];
  final generator = GeneratorFactory(manager, Options(
    format: fmt!,
    root: p.join(rootDir, out),
  ));

  final output = Output(generator);
  output.generate();
}
