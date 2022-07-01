import 'package:dartbook_html/langs.dart';

abstract class Parser {
  String get name;

  /// extension name of supported file
  Iterable<String> get ext;

  Langs langs(String md);
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
