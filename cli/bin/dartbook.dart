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
  final parser = ContentParser();
  final assembler = BookAssembler(logger, parser);

  final rootDir = p.absolute(root);
  final manager = assembler.assemble(root: rootDir);

  final fmt = options['format'];
  final generator = Generator(fmt!, Options(
    root: p.join(rootDir, out),
  ));

  final output = Output(generator, parser);
  output.generate(manager);
}
