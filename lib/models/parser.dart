import 'package:dartbook/html/html.dart';

import 'book.dart';

abstract class Parser {
  String get name;

  /// extension name of supported file
  Iterable<String> get ext;

  Iterable<Article> langs(String content);

  ({String title, String? desc}) readme(String content);

  Iterable<Part> summary(String content);

  Iterable<({String name, String? desc})> glossary(String content);

  String page(String content);

  /// parse pages in book and put them all in it
  void pages(Book book);
}

class ParserManager {
  final Map<String, Parser> parsers;

  ParserManager(Iterable<Parser> list)
      : parsers = { for (final p in list) p.name : p };

  Parser? operator [](String name) => parsers[name];

  Iterable<String> get allExtensions => [
    for (final p in parsers.values) ...p.ext,
  ];

  Parser? byExt(String ext) {
    for (final p in parsers.values) {
      if (p.ext.contains(ext)) {
        return p;
      }
    }
    return null;
  }
}
