
import 'dart:io' show File;

import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/page.dart';
import 'package:path/path.dart' as p;

import 'context.dart';
import 'template/template_engine.dart';

class Options {
  final String format;
  /// Root folder for the output
  final String root;
  /// Prefix for generation
  final String? prefix;
  /// Use directory index url instead of "index.html"
  final bool directoryIndex;

  const Options({
    required this.format,
    required this.root,
    this.prefix,
    this.directoryIndex = true,
  });

  Options copyWith({String? format, String? root, String? prefix, bool? index}) {
    return Options(
      format: format ?? this.format,
      root: root ?? this.root,
      prefix: prefix ?? this.prefix,
      directoryIndex: index ?? directoryIndex,
    );
  }
}

class Generator {
  final Options opt;
  final BookContext context;
  final TemplateEngine engine;

  Generator(this.opt, this.context, this.engine);

  static _toOutputName(Book book, String filename) {
    final readme = book.readme;
    final base = p.basename(filename);
    final name = base == 'README' || readme.filename == filename
        ? p.normalize(p.join(p.dirname(filename), 'index.html'))
        : p.setExtension(filename, '.html');
    return name;
  }

  void generatePages(Book book) {
    final logger = context.logger;
    final pages = book.pages;
    for (final page in pages.values) {
      try {
        _generatePage(book, page);
      } on Exception catch (e) {
        logger.d("generate page '${page.filename}' failed by ${e.toString()}, ignored.");
      }
    }
  }

  void _attachPageContent(BookPage page, String filePath) {
    try {
      final parser = context.parser;
      final htmlPage = parser.page(File(filePath).readAsStringSync());
      page.content = htmlPage.content;
    } on Exception catch (e) {
      final logger = context.logger;
      logger.e('_attachPageContent error: $e');
    }
  }

  void _generatePage(Book book, BookPage page) {
    final filename = page.filename;
    _attachPageContent(page, p.join(book.root, filename));
    final outputName = _toOutputName(book, filename);
    final out = File(p.join(opt.root, outputName));
    if (!out.parent.existsSync()) {
      out.createSync(recursive: true);
    }
    final data = _makeBookRenderData(book, page);
    final result = engine.renderPage(data);
    out.writeAsStringSync(result);
  }

  Map<String, dynamic> _makeBookRenderData(Book book, BookPage page) {
    final config = context.config;
    final summary = book.summary.json;

    final result = <String, dynamic>{
      'page': {
        'dir': page.dir,
        'content': page.content,
      },
      ...summary,
      'glossary': {
      },
      'file': {
      },
      'gitbook': {
      },
      'template': {
        'getJSContext': () {
          return {};
        }
      },
      'getPageByPath': (String path) {
        return book.pages[path];
      },
      'plugins': {
        'resources': {
          'js': [],
          'css': [
          ]
        }
      },
    };
    final conf = Map.of(config.values);
    conf.addAll(<String, dynamic>{
      'styles': <String, String>{
        // "website": "styles/website.css",
      },
      'links': {
      },
      'pluginsConfig': {
        'theme-default': {
          'showLevel': 2,
        }
      },
      'language': book.lang,
    });
    result['config'] = conf;
    return result;
  }

  void lingualIndex(LanguageManager langMgr) {
    final content = engine.renderLingualIndex(_makeLingualIndexData(langMgr));
    File(p.join(opt.root, 'index.html')).writeAsStringSync(content);
  }

  Map<String, dynamic> _makeLingualIndexData(LanguageManager langMgr) {
    final config = context.config;
    final result = <String, dynamic>{
      'page': {
        'dir': "ltr",
      },
      'gitbook': {
      },
      'template': {
        'getJSContext': () {
          return {};
        }
      },
      'plugins': {
        'resources': {
          'js': [],
          'css': [
          ]
        }
      },
      'config': {
        ...config.values,
        'styles': <String, String>{
          // "website": "styles/website.css",
        },
        'links': {
        },
        'pluginsConfig': {
          'theme-default': {
            'showLevel': 2,
          }
        },
        'language': 'en'
      },
      ...langMgr.json,
    };
    return result;
  }
}
