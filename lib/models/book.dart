
import 'package:path/path.dart' as p;

import 'article.dart';
import 'config.dart';
import 'glossary.dart';
import 'ignore.dart';
import 'page.dart';
import 'readme.dart';
import 'summary.dart';

class Book {
  /// root directory of book
  final String bookPath;
  /// path of lingual book
  final String langPath;
  final BookIgnore ignore;

  /// Structure files
  final BookConfig config;
  final BookReadme readme;
  final BookSummary summary;
  final BookGlossary glossary;
  /// language from config, e.g. book.json
  final String? lang;

  /// pages in a book
  final pages = <String, BookPage>{};
  /// assets in a book
  final assets = <String>[];

  Book({
    required this.bookPath,
    required this.langPath,
    required this.ignore,
    required this.config,
    required this.readme,
    required this.summary,
    required this.glossary,
    this.lang,
  });

  factory Book.empty(String lang) {
    return Book(
      bookPath: '',
      langPath: lang,
      ignore: BookIgnore(),
      config: BookConfig('', {}),
      readme: BookReadme(filename: '', title: ''),
      summary: BookSummary('', []),
      glossary: BookGlossary('', {}),
    );
  }

  /// project root directory of whole book
  String get root => langPath.isEmpty
      ? bookPath
      : p.normalize(p.join(bookPath, p.relative('.', from: langPath)));

  String fileFsPath(String path) => p.join(bookPath, path);

  /// path relative to project root
  String filePath(String path) => p.join(langPath, path);

  /// Return true if book is one of multilingual books
  bool get lingual => langPath.isNotEmpty;

  /// language intent to show in html
  String get language => lang ?? langPath;

  bool isIgnoredFile(String filename) {
    final l = langPath;
    if (l.isNotEmpty) {
      filename = p.join(l, filename);
    }
    return ignore.isIgnored(filename);
  }

  bool isContentFileIgnored(String filename) {
    final root = config['root'];
    if (root != null) {
      filename = p.join(root, filename);
    }
    return isIgnoredFile(filename);
  }

  bool isAsset(String filename) {
    return filename != readme.filename
        && filename != summary.filename
        && filename != glossary.filename
        && filename != config.filename
        && !pages.keys.contains(filename)
        && !isIgnoredFile(filename);
  }

  Map<String, dynamic> pageJson(BookPage page, {bool withContent = true}) {
    final file = page.filename;
    final article = summary.byPath(file);
    final attributes = page.attributes;
    return {
      'page': {
        if (withContent)
          'content': page.content,
        'dir': page.dir,
        if (attributes != null)
          ...attributes,
        if (article != null)
          ...navJson(article),
      },
      'file': {
        'path': file,
      },
    };
  }

  Map<String, dynamic> navJson(SummaryArticle article) {
    final next = summary.nextArticle(article);
    final prev = summary.prevArticle(article);
    return {
      'title': article.title,
      'level': article.level,
      'depth': article.depth,
      if (next != null)
        'next': next.json,
      if (prev != null)
        'previous': prev.json,
    };
  }

  static const _skipName = {'', '.', '..'};
  static const _extNames = {
    '.md': '.html',
  };

  String outputName(String filename) {
    filename = p.normalize(filename);
    final base = p.basename(filename);
    final newExt = _extNames[p.extension(filename)];
    final name = base == 'README' || readme.filename == filename
        ? p.join(p.dirname(filename), 'index.html')
        : _skipName.contains(filename)
        ? filename
        : newExt != null
        ? p.setExtension(filename, newExt)
        : filename;
    return p.normalize(name);
  }
}
