
import 'package:dartbook_models/page.dart';
import 'package:path/path.dart' as path;

import 'config.dart';
import 'glossary.dart';
import 'ignore.dart';
import 'readme.dart';
import 'summary.dart';

class Book {
  final String bookPath;
  final BookIgnore ignore;

  /// Structure files
  final BookConfig config;
  final BookReadme readme;
  final BookSummary summary;
  final BookGlossary glossary;
  final String? lang;

  /// pages in a book
  final pages = <String, BookPage>{};
  /// assets in a book
  final assets = <String>[];

  Book({
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

  bool isAsset(String filename) {
    return filename != readme.filename
        && filename != summary.filename
        && filename != glossary.filename
        && filename != config.filename
        && !pages.keys.contains(filename)
        && !isIgnoredFile(filename);
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
