import 'dart:io' show File;

class BookLanguage {
  final String title;
  final String path;

  const BookLanguage(this.title, this.path);

  String get id {
    final p = path.endsWith('/') ? path.substring(0, path.length - 1) : path;
    return p.split('/').last;
  }
}

class LanguageManager {
  final String filename;
  final Map<String, BookLanguage> items;

  const LanguageManager(this.filename, this.items);

  factory LanguageManager.create(String file, Iterable<BookLanguage> list) {
    final map = { for (final e in list) e.id : e };
    return LanguageManager(file, map);
  }

  File get file => File(filename);

  BookLanguage? operator [](String key) => items[key];
}
