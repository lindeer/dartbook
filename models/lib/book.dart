
import 'package:path/path.dart' as path;

import 'config.dart';
import 'glossary.dart';
import 'ignore.dart';
import 'language.dart';
import 'logger.dart';
import 'readme.dart';
import 'summary.dart';

class Book {
  final Logger logger;
  final String bookPath;
  final BookIgnore ignore;

  /// Structure files
  final BookConfig config;
  final BookReadme readme;
  final BookSummary summary;
  final BookGlossary glossary;
  final String? lang;

  Book({
    required this.logger,
    required this.bookPath,
    required this.ignore,
    required this.config,
    required this.readme,
    required this.summary,
    required this.glossary,
    this.lang,
  });

  String get root {
    return bookPath;
  }

  String get contentRoot {
    final root = config['root'];
    return root;
  }

  /// Return true if book is associated to a language
  bool get isLanguageBook => lang != null;

  bool isIgnoredFile(String filename) {
    final l = lang;
    if (l != null) {
      filename = path.join(l, filename);
    }
    return ignore.isIgnored(filename);
  }

  bool isContentFileIgnored(String filename) {
    final root = config['root'];
    if (root != null) {
      filename = path.join(root, filename);
    }
    return isIgnoredFile(filename);
  }

  /*
  /// Infers the default extension for files
  String get defaultExt {
    final exts = [
      readme.filename,
      summary.filename,
      glossary.filename,
    ].map((f) {
      final file = File(f);
      return file.existsSync() ? parser.ext.first : null;
    }).whereType<String>();
    return [...exts, '.md'].first;
  }

  String _defaultPath(String name, bool absolute) {
    final filename = '$name$defaultExt';
    return absolute ? path.join(contentRoot, filename) : filename;
  }

  String readmeDefaultPath(bool absolute) => _defaultPath('README', absolute);

  String summaryDefaultPath(bool absolute) => _defaultPath('SUMMARY', absolute);

  String glossaryDefaultPath(bool absolute) => _defaultPath('GLOSSARY', absolute);
  */
}

class BookManager {
  final String root;
  final Logger logger;
  final Map<String, Book> books;
  final LanguageManager? langManager;
  final BookIgnore ignore;
  final BookConfig config;

  BookManager({
    required this.root,
    required this.logger,
    required this.books,
    required this.langManager,
    required this.ignore,
    required this.config,
});

  /// Is this book the parent of language's books
  bool get isMultilingual => (langManager?.items.length ?? 1) > 1;

  Book? operator [](String lang) => books[lang];

  /// Add a new language book
  void operator []=(String lang, Book book) => books[lang] = book;

  /*
  Book create(String lang) {
    final c = BookConfig(config.filename, config.values);
    c['language'] = lang;
    return Book(
      logger: logger,
      bookPath: path.join(root.path, lang),
      ignore: ignore,
      config: c,
      readme: BookReadme(filename: 'README.md', title: ''),
      summary: BookSummary('SUMMARY.md', []),
      glossary: BookGlossary('GLOSSARY.md', {}),
      parser: parserManager['md']!,
    );
  }
   */
}
