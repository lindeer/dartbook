
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/config.dart';
import 'package:dartbook_models/ignore.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/logger.dart';

import 'parser.dart';

class BookContext {
  final Logger logger;
  final ContentParser parser;
  final String root;
  final Map<String, Book> books;
  final LanguageManager? langManager;
  final BookIgnore ignore;
  final BookConfig config;

  BookContext({
    required this.logger,
    required this.parser,
    required this.root,
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
}
