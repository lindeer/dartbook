
import 'dart:io' show File;

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

  const Generator.__(this.name, this.opt);

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

  WebGenerator(this.context, Options opt) : super.__('website', opt);

  @override
  void prepare(BookContext context, String bookKey) {
  }

  @override
  void init(BookContext context, String bookKey) {
  }

  @override
  void finish(BookContext context, String bookKey) {
  }

  static _toOutputName(Book book, String filename) {
    final readme = book.readme;
    final base = p.basename(filename);
    final name = base == 'README' || readme.filename == filename
        ? p.normalize(p.join(p.dirname(filename), 'index.html'))
        : p.setExtension(filename, '.html');
    return name;
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
    final parser = context.parser;
    final bookPage = parser.page(p.join(book.root, filename));
    final result = _toOutputName(book, filename);
    final out = File(p.join(opt.root, result));
    if (!out.parent.existsSync()) {
      out.createSync(recursive: true);
    }
    final content = bookPage.content;
    if (content != null) {
      out.writeAsStringSync(content);
    }
  }
}
