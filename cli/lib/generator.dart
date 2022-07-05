
import 'dart:io' show File;

import 'package:dartbook_markdown/md_parser.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/page.dart';
import 'package:path/path.dart' as p;

import 'context.dart';

class Options {
  final String format;
  /// Root folder for the output
  final String root;
  /// Prefix for generation
  final String? prefix;
  /// Use directory index url instead of "index.html"
  final bool directoryIndex;

  const Options({
    required this.format,
    required this.root,
    this.prefix,
    this.directoryIndex = true,
  });
}

typedef _GeneratorCreator = Generator Function(Options opt);

abstract class Generator {
  final String name;
  final Options opt;
  final MdParser parser;

  const Generator.__(this.name, this.opt, this.parser);

  // TODO: prepare(BookContext context, Book book)
  void prepare(BookContext context, String bookKey);

  void generateAssets(Iterable<String> assets) {
  }

  void generatePages(Book book) {
  }

  void init(BookContext context, String bookKey);

  void finish(BookContext context, String bookKey);
}

class GeneratorFactory {
  final BookContext context;
  final Options opt;
  final Map<String, _GeneratorCreator> _factories;

  GeneratorFactory(this.context, this.opt)
      : _factories = <String, _GeneratorCreator> {
    'website' : (Options opt) => WebGenerator(context, opt),
  };

  Generator create({String? format, String? root, String? prefix, bool? index}) {
    final newOpt = Options(
      format: format ?? opt.format,
      root: root ?? opt.root,
      prefix: prefix ?? opt.prefix,
      directoryIndex: index ?? opt.directoryIndex,
    );
    return _factories[newOpt.format]!.call(newOpt);
  }
}

class WebGenerator extends Generator {
  final BookContext context;

  WebGenerator(this.context, Options opt) : super.__('website', opt, MdParser());

  @override
  void prepare(BookContext context, String bookKey) {
  }

  @override
  void init(BookContext context, String bookKey) {
  }

  @override
  void finish(BookContext context, String bookKey) {
  }

  static String _toHtmlName(String filename) {
    int pos = filename.lastIndexOf(p.extension(filename));
    return pos > 0 ? '${filename.substring(0, pos)}.html' : filename;
  }

  @override
  void generatePages(Book book) {
    final logger = context.logger;
    final pages = book.pages;
    for (final page in pages.values) {
      try {
        _generatePage(book, page);
      } on Exception catch (e) {
        logger.d("generate page '${page.filename}' failed by ${e.toString()}, ignored.");
      }
    }
  }

  void _generatePage(Book book, BookPage page) {
    final filename = page.filename;
    final file = File(p.join(book.root, filename));
    final content = file.readAsStringSync();
    final mdPage = parser.page(content);
    final result = _toHtmlName(filename);
    final out = File(p.join(opt.root, result));
    if (!out.parent.existsSync()) {
      out.createSync(recursive: true);
    }
    out.writeAsStringSync(mdPage.content);
  }
}
