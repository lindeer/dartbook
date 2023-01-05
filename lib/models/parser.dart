import 'package:dartbook_html/glossary.dart';
import 'package:dartbook_html/langs.dart';
import 'package:dartbook_html/page.dart';
import 'package:dartbook_html/readme.dart';
import 'package:dartbook_html/summary.dart';

import 'book.dart';

abstract class Parser {
  String get name;

  /// extension name of supported file
  Iterable<String> get ext;

  Langs langs(String content);

  Readme readme(String content);

  Summary summary(String content);

  Iterable<Glossary> glossary(String content);

  Page page(String content);

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
