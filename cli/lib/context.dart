import 'dart:collection' show Queue;
import 'dart:convert' show json;
import 'dart:io' show Directory, File, FileSystemEntity, IOException;

import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/config.dart';
import 'package:dartbook_models/const/config.dart';
import 'package:dartbook_models/const/configDefault.dart';
import 'package:dartbook_models/const/ignore.dart';
import 'package:dartbook_models/glossary.dart';
import 'package:dartbook_models/ignore.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/parser.dart';
import 'package:dartbook_models/readme.dart';
import 'package:dartbook_models/summary.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:path/path.dart' as p;

import 'logger.dart';

class BookContext {
  final Logger logger;
  final Parser parser;
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
  bool get isMultilingual => langManager != null;

  Book? operator [](String lang) => books[lang];

  /// Add a new language book
  void operator []=(String lang, Book book) => books[lang] = book;

  static BookContext assemble({
    required String root,
    required Logger logger,
    required Parser parser,
  }) {
    return _Assembler(logger: logger, parser: parser)
        .assemble(root);
  }

  Iterable<String> listAssets({bool relative = false}) {
    final assets = [
      if (isMultilingual)
        ..._filterFilesIn(root, (f) => !ignore.isIgnored(f)),
      for (final book in books.values)
        ..._filterFilesIn(book.bookPath, book.isAsset),
    ];
    return relative ? assets.map((e) => p.relative(e, from: root)) : assets;
  }

  static Iterable<String> _filterFilesIn(String dir, bool Function(String path) filter) {
    final queue = Queue.of([Directory(dir)]);
    final result = <String>[];
    while (queue.isNotEmpty) {
      final d = queue.removeFirst();
      for (final f in d.listSync(recursive: false)) {
        final path = f.path;
        final filename = p.relative(path, from: dir);

        if (filter(filename)) {
          if (FileSystemEntity.isDirectorySync(path)) {
            queue.add(Directory(path));
          } else {
            result.add(path);
          }
        }
      }
    }
    return result;
  }
}

const _defaultIgnores = [
  // Skip Git stuff
  '.git/',

  // Skip OS X meta data
  '.DS_Store',

  // Skip stuff installed by plugins
  'node_modules',

  // Skip book outputs
  '_book',

  // Ignore files in the templates folder
  '_layouts'
];


class _ResultHolder {
  final String bookPath;
  final String logLevel;
  bool isLangBook = false;
  final BookIgnore ignore;
  BookConfig? config;
  LanguageManager? langs;

  _ResultHolder(this.bookPath, this.logLevel): ignore = BookIgnore();

  String path(String filename) => p.join(bookPath, filename);
}

class _Assembler {
  final Logger logger;
  final Parser parser;

  _Assembler({required this.logger, required this.parser});

  BookContext assemble(String root) {
    final holder = _ResultHolder(root,'info');
    _parseIgnore(holder);
    _parseConfig(holder);
    final langs = holder.langs =
        _safeParseStructure(holder, 'langs', _makeLanguageManager);
    Map<String, Book> books;
    if ((langs?.items.length ?? 0) > 0) {
      holder.isLangBook = true;
      books = _parseMultilingual(holder);
    } else {
      final result = _parseSkeleton(holder);
      books = { "" : result };
    }
    return BookContext(
      logger: logger,
      parser: parser,
      root: root,
      books: books,
      langManager: langs,
      ignore: holder.ignore,
      config: holder.config!,
    );
  }

  BookIgnore _parseIgnore(_ResultHolder holder) {
    final ignore = holder.ignore;
    if (holder.isLangBook) {
      return ignore;
    }
    ignore.addAll(_defaultIgnores);
    for (final f in ignoreFiles) {
      final file = File(holder.path(f));
      try {
        final rules = file.readAsLinesSync().where((line) => !line.startsWith('#'));
        ignore.addAll(rules);
      } on Exception catch (e) {
        logger.d("parse ignore '${file.path}' error: $e");
      }
    }
    return ignore;
  }

  BookConfig? _parseConfig(_ResultHolder holder) {
    final ignore = holder.ignore;
    final files = configFiles.where((f) => !ignore.isIgnored(f));

    for (final f in files) {
      File file = File(holder.path(f));
      if (!file.existsSync()) {
        continue;
      }
      final config = BookConfig.schemaDefault();
      try {
        final jsonObj = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        final result = _validateConfig(jsonObj);
        config.addAll(result);
        holder.config ??= BookConfig(f, config);
      } on Exception catch (e) {
        logger.d("parse config '${file.path}' error: $e");
      }
    }
    holder.config ??= BookConfig.withDefault('');
    return holder.config;
  }

  Map<String, dynamic> _validateConfig(Map<String, dynamic> config) {
    final schema = JsonSchema.createSchema(configSchema);
    final errors = schema.validateWithErrors(config);
    if (errors.isNotEmpty) {
      final error = errors.first;
      throw Exception("Config validation failed: '${error.message}', "
          "by '${error.instancePath}' but schema is '${error.schemaPath}'");
    }
    return config;
  }

  Map<String, Book> _parseMultilingual(_ResultHolder parent) {
    final langs = parent.langs!;
    final children = langs.items.values.map((lang) {
      final id = lang.id;
      final child = _ResultHolder(parent.path(id), 'info');
      child.ignore
        ..update(parent.ignore)
        ..add('$id/**');
      parent.ignore.add(lang.path);
      _parseConfig(child);
      final book = _parseSkeleton(child);
      return MapEntry(id, book);
    });

    parent.ignore.add(langs.filename);

    return Map.fromEntries(children);
  }

  Book _parseSkeleton(_ResultHolder holder) {
    final readme = _parseStructure(holder, 'readme', _makeReadme);
    final summary = _parseStructure(holder, 'summary', _makeSummary);
    final glossary = _safeParseStructure(holder, 'glossary', _makeGlossary)
        ?? BookGlossary('', {});

    final book = Book(
      bookPath: holder.bookPath,
      ignore: holder.ignore,
      config: holder.config!,
      readme: readme,
      summary: summary,
      glossary: glossary,
    );
    parser.pages(book);
    return book;
  }

  LanguageManager _makeLanguageManager(String filename, String content) =>
      LanguageManager.create(filename, parser.langs(content));

  BookReadme _makeReadme(String filename, String content) =>
      BookReadme.create(filename, parser.readme(content));

  BookSummary _makeSummary(String filename, String content) =>
      BookSummary.create(filename, parser.summary(content));

  BookGlossary _makeGlossary(String filename, String content) =>
      BookGlossary.fromItems(filename, parser.glossary(content));

  /// Lookup a structure file (ex: SUMMARY.md, GLOSSARY.md) in a book. Uses
  /// book's config to find it.
  T _parseStructure<T>(_ResultHolder holder, String type,
      T Function(String filename, String content) func) {
    final filename = holder.config?['structure.$type'] as String?;
    if (filename == null) {
      throw Exception("Not found '$type' type in config");
    }
    final path = holder.path(filename);
    try {
      final content = File(path).readAsStringSync();
      return func(filename, content);
    } on IOException catch (e) {
      logger.e("Parse '$path' error by $e}");
      rethrow;
    }
  }

  T? _safeParseStructure<T>(_ResultHolder holder, String type,
      T Function(String filename, String content) func) {
    try {
      return _parseStructure(holder, type, func);
    } on Exception {
      return null;
    }
  }
}
