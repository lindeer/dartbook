import 'package:dartbook_html/langs.dart';

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

  factory LanguageManager.create(String file, Langs langs) {
    final list = langs.articles.map((e) => BookLanguage(e.title, e.ref ?? ''));
    final map = { for (final e in list) e.id : e };
    return LanguageManager(file, map);
  }

  BookLanguage? operator [](String key) => items[key];

  Map<String, dynamic> get json => {
    'languages': {
      'file': {
        'path': filename,
      },
      'list': items.entries.map((e) => <String, String>{
        'id': e.key,
        'title': e.value.title,
      }),
    }
  };
}
