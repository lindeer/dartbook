import 'dart:collection' show Queue;
import 'dart:convert' show json;
import 'dart:io' show Directory, File, FileSystemEntity, IOException;

import 'package:dartbook/models/book.dart';
import 'package:dartbook/models/config.dart';
import 'package:dartbook/models/const/config.dart';
import 'package:dartbook/models/const/config_default.dart';
import 'package:dartbook/models/const/ignore.dart';
import 'package:dartbook/models/glossary.dart';
import 'package:dartbook/models/ignore.dart';
import 'package:dartbook/models/language.dart';
import 'package:dartbook/models/parser.dart';
import 'package:dartbook/models/readme.dart';
import 'package:dartbook/models/summary.dart';
import 'package:json_schema/json_schema.dart' show JsonSchema;
import 'package:path/path.dart' as p;

import 'logger.dart';
import 'parser.dart';

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
    Map<String, String>? options,
  }) {
    final logger = Logger(options?['verbose'] == "true");
    final parser = MarkdownParser(logger);
    return _Assembler(logger: logger, parser: parser)
        .assemble(root, options);
  }

  bool _isIgnoreFile(String f) => ignoreFiles.contains(p.basename(f));

  Iterable<String> listAssets({bool relative = false}) {
    final assets = [
      if (isMultilingual)
        ..._filterFilesIn(root, (f) => !_isIgnoreFile(f) && !ignore.isIgnored(f)),
      for (final book in books.values)
        ..._filterFilesIn(book.bookPath, (f) => !_isIgnoreFile(f) && book.isAsset(f)),
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

  // Skip book theme
  'theme',

  // Ignore files in the templates folder
  '_layouts'
];

class _ResultHolder {
  final String fsRoot;
  final String langPath;
  final Map<String, String>? params;
  final BookIgnore ignore;
  final BookConfig config;

  const _ResultHolder(this.fsRoot, this.langPath, this.params,
      this.ignore, this.config);

  String path(String filename) => p.join(fsRoot, filename);
}

class _Assembler {
  final Logger logger;
  final Parser parser;

  _Assembler({required this.logger, required this.parser});

  BookContext assemble(String root, [Map<String, String>? params]) {
    final ignore = _parseIgnore(root);
    final config = _parseConfig(root, ignore);
    final holder = _ResultHolder(root, '', params, ignore, config);
    final langs = _safeParseStructure(holder, 'langs', _makeLanguageManager);
    late final Map<String, Book> books;
    if (langs != null && langs.items.isNotEmpty) {
      books = _parseMultilingual(holder, langs);
    } else {
      final result = _parseSkeleton(holder);
      books = {"": result};
    }
    return BookContext(
      logger: logger,
      parser: parser,
      root: root,
      books: books,
      langManager: langs,
      ignore: ignore,
      config: config,
    );
  }

  BookIgnore _parseIgnore(String root) {
    final ignore = BookIgnore();
    ignore.addAll(_defaultIgnores);
    for (final f in ignoreFiles) {
      final file = File(p.join(root, f));
      try {
        final rules = file.readAsLinesSync().where((line) => !line.startsWith('#'));
        ignore.addAll(rules);
      } on Exception catch (e) {
        logger.d("parse ignore '${file.path}' error: $e");
      }
    }
    return ignore;
  }

  BookConfig _parseConfig(String root, BookIgnore ignore) {
    final configs = configFiles.where((f) => !ignore.isIgnored(f)).map((f) {
      final file = File(p.join(root, f));
      return file.existsSync() ? (f, file) : null;
    }).whereType<(String, File)>().map((e) {
      final (f, file) = e;
      final config = BookConfig.schemaDefault();
      try {
        final jsonObj = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        final result = _validateConfig(jsonObj);
        config.addAll(result);
        return BookConfig(f, config);
      } on Exception catch (e) {
        logger.d("parse config '${file.path}' error: $e");
        return null;
      }
    }).whereType<BookConfig>();
    return configs.isEmpty ? BookConfig.withDefault('') : configs.first;
  }

  Map<String, dynamic> _validateConfig(Map<String, dynamic> config) {
    final schema = JsonSchema.create(configSchema);
    final errors = schema.validate(config).errors;
    if (errors.isNotEmpty) {
      final error = errors.first;
      throw Exception("Config validation failed: '${error.message}', "
          "by '${error.instancePath}' but schema is '${error.schemaPath}'");
    }
    return config;
  }

  Map<String, Book> _parseMultilingual(_ResultHolder parent, LanguageManager langs) {
    // Parent's rule changed later, keep the origin value.
    final rules = List.of(parent.ignore.rules);
    final children = langs.items.map((lang) {
      final id = lang.id;
      final root = parent.path(id);
      final ignore = BookIgnore()..addAll(rules);
      final config = _parseConfig(root, ignore);
      final child = _ResultHolder(root, id, parent.params, ignore, config);
      final book = _parseSkeleton(child);
      return (id, book);
    });

    parent.ignore.add(langs.filename);
    parent.ignore.addAll(children.map((e) => e.$1));

    return {for (final (k, v) in children) k: v};
  }

  Book _parseSkeleton(_ResultHolder holder) {
    final readme = _parseStructure(holder, 'readme', _makeReadme);
    final summary = _parseStructure(holder, 'summary', (String filename, String content) {
      return BookSummary.create(filename, parser.summary(content), readme);
    });
    final glossary = _safeParseStructure(holder, 'glossary', _makeGlossary)
        ?? BookGlossary('', {});

    final book = Book(
      bookPath: holder.fsRoot,
      langPath: holder.langPath,
      ignore: holder.ignore,
      config: holder.config,
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

  BookGlossary _makeGlossary(String filename, String content) =>
      BookGlossary.fromItems(filename, parser.glossary(content));

  /// Lookup a structure file (ex: SUMMARY.md, GLOSSARY.md) in a book. Uses
  /// book's config to find it.
  T _parseStructure<T>(_ResultHolder holder, String type,
      T Function(String filename, String content) func) {
    final filename = holder.config['structure.$type'] as String?;
    if (filename == null) {
      throw Exception("Not found '$type' type in config");
    }
    final path = holder.path(filename);
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception("Not fount '$filename'");
    }
    try {
      final content = file.readAsStringSync();
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
