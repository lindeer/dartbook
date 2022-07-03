
import 'dart:io' show File;

import 'package:dartbook_markdown/md_parser.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/page.dart';
import 'package:path/path.dart' as p;

class Options {
  /// Root folder for the output
  final String root;
  /// Prefix for generation
  final String? prefix;
  /// Use directory index url instead of "index.html"
  final bool directoryIndex;

  const Options({
    required this.root,
    this.prefix,
    this.directoryIndex = true,
  });

  Options copyWith({String? root, String? prefix, bool? index}) {
    return Options(
      root: root ?? this.root,
      prefix: prefix ?? this.prefix,
      directoryIndex: index ?? directoryIndex,
    );
  }
}

typedef GeneratorFactory = Generator Function(Options opt);

final _factories = <String, GeneratorFactory> {
  'website' : (Options opt) => WebGenerator(opt),
};

abstract class Generator {
  final String name;
  final Options opt;
  final MdParser parser;

  const Generator.__(this.name, this.opt, this.parser);

  factory Generator(String name, Options opt) => _factories[name]!.call(opt);

  // TODO: prepare(BookContext context, Book book)
  void prepare(BookManager manager, String bookKey);

  void generateAssets(BookManager manager, Iterable<String> assets) {
  }

  static String _toHtmlName(String filename) {
    int pos = filename.lastIndexOf(p.extension(filename));
    return pos > 0 ? '${filename.substring(0, pos)}.html' : filename;
  }

  void generatePages(Book book, Map<String, BookPage> pages) {
    final logger = book.logger;
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

  void init(BookManager manager, String bookKey);

  void finish(BookManager manager, String bookKey);
}

class WebGenerator extends Generator {
  WebGenerator(Options opt) : super.__('website', opt, MdParser());

  @override
  void prepare(BookManager manager, String bookKey) {
  }

  @override
  void init(BookManager manager, String bookKey) {
  }

  @override
  void finish(BookManager manager, String bookKey) {
  }
}
