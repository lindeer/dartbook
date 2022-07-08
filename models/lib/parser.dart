import 'book.dart';
import 'glossary.dart';
import 'language.dart';
import 'page.dart';
import 'readme.dart';
import 'summary.dart';

abstract class Parser {
  String get name;

  /// extension name of supported file
  Iterable<String> get ext;

  LanguageManager langs(String filePath);

  BookReadme readme(String filePath);

  BookSummary summary(String filePath);

  BookGlossary glossary(String filePath);

  BookPage page(String filePath);

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
