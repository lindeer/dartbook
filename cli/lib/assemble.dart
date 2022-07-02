import 'dart:convert' show json;
import 'dart:io' show Directory, File;

import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/config.dart';
import 'package:dartbook_models/const/config.dart';
import 'package:dartbook_models/const/ignore.dart';
import 'package:dartbook_models/glossary.dart';
import 'package:dartbook_models/ignore.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/logger.dart';
import 'package:dartbook_models/readme.dart';
import 'package:dartbook_models/summary.dart';
import 'package:path/path.dart' as p;

import 'parser.dart';

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

  factory _ResultHolder.from(Iterable<String> args, Map<String, String> options) {
    final dir = args.isNotEmpty ? args.first : Directory.current.path;
    return _ResultHolder(dir, options['log'] ?? 'info');
  }
}

class BookAssembler {
  final Logger logger;
  final ContentParser parser;

  BookAssembler(this.logger, this.parser);

  BookManager assemble(Iterable<String> args, Map<String, String> options) {
    final holder = _ResultHolder.from(args, options);
    _parseIgnore(holder);
    _parseConfig(holder);
    final langs = _parseLanguages(holder);
    Map<String, Book> books;
    if ((langs?.items.length ?? 0) > 0) {
      holder.isLangBook = true;
      books = _parseMultilingual(holder);
    } else {
      final result = _parseSkeleton(holder);
      books = { "" : result };
    }
    return BookManager(
      logger: logger,
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
      try {
        final jsonObj = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        final result = _validateConfig(jsonObj);
        final config = holder.config ?? BookConfig.withDefault(file.path);
        config.merge(result);
        holder.config = config;
      } on Exception catch (e) {
        logger.d("parse config '${file.path}' error: $e");
      }
    }
    return holder.config;
  }

  // TODO: need json_schema: 4.0.3
  Map<String, dynamic> _validateConfig(Map<String, dynamic> config) {
    return config;
  }

  LanguageManager? _parseLanguages(_ResultHolder holder) {
    final langs = _lookupStructure(holder, 'langs');
    if (langs != null) {
      final mgr = parser.langs(langs);
      holder.langs = mgr;
    }
    return holder.langs;
  }

  /// Lookup a structure file (ex: SUMMARY.md, GLOSSARY.md) in a book. Uses
  /// book's config to find it.
  File? _lookupStructure(_ResultHolder holder, String type) {
    final filename = holder.config?['structure.$type'] as String?;
    if (filename != null) {
      final file = File(holder.path(filename));
      if (file.existsSync()) {
        return file;
      }
    }
    return null;
  }

  Map<String, Book> _parseMultilingual(_ResultHolder parent) {
    final langs = parent.langs!;
    final children = langs.items.values.map((lang) {
      final id = lang.id;
      final child = _ResultHolder(parent.path(id), 'info');
      child.ignore
        ..update(parent.ignore)
        ..add('$id/**');
      _parseConfig(child);
      final book = _parseSkeleton(child);
      return MapEntry(id, book);
    });

    return Map.fromEntries(children);
  }

  Book _parseSkeleton(_ResultHolder holder) {
    final readme = _parseStructure<BookReadme>(holder, 'readme', parser.readme);
    final summary = _parseStructure<BookSummary>(holder, 'summary', parser.summary);
    final glossary = _parseStructure<BookGlossary>(holder, 'glossary', parser.glossary);

    return Book(
      logger: logger,
      bookPath: holder.bookPath,
      ignore: holder.ignore,
      config: holder.config!,
      readme: readme,
      summary: summary,
      glossary: glossary,
    );
  }

  T _parseStructure<T>(_ResultHolder holder, String type, T Function(File file) func) {
    final item = _lookupStructure(holder, type);
    if (item == null) {
      throw Exception("'${type.toUpperCase()}' not found!");
    }
    return func(item);
  }
}