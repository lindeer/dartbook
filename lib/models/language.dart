import 'package:path/path.dart' as p;
import 'package:dartbook/html/html.dart' show Article;

class BookLanguage {
  final String title;
  final String path;
  final String id;

  const BookLanguage._(this.title, this.path, this.id);

  factory BookLanguage(String title, String path) =>
      BookLanguage._(title, path, p.basename(path));
}

class LanguageManager {
  final String filename;
  final Iterable<BookLanguage> items;

  const LanguageManager(this.filename, this.items);

  factory LanguageManager.create(String file, Iterable<Article> langs) {
    final list = langs.map((e) => BookLanguage(e.title, e.ref ?? ''));
    return LanguageManager(file, list);
  }

  Map<String, dynamic> get json => {
        'languages': {
          'file': {
            'path': filename,
          },
          'list': items.map((e) => <String, String>{
                'id': e.id,
                'title': e.title,
              }),
        },
      };
}
