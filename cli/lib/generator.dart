
import 'dart:convert' show json;

import 'package:dartbook/theme_manager.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/config.dart';
import 'package:dartbook_models/page.dart';
import 'package:path/path.dart' as p;

import 'context.dart';

class Generator {
  final ThemeManager theme;
  final bool directoryIndex;

  Generator({
    required this.theme,
    required this.directoryIndex,
  });

  final _builtinFilters = <String, Function>{
    'resolveAsset': (f) {
      final filepath = p.join('/gitbook', f);
      return filepath;
    },
    'contentURL': (path) => p.dirname(path),
    'fileExists': (f) => true,
  };

  String _toUrl(Book book, String filename) {
    if (filename.startsWith('/')) {
      filename = filename.substring(1);
    }
    String file = book.outputName(filename);
    if (directoryIndex && p.basename(file) == 'index.html') {
      file = p.dirname(file);
    }
    return p.normalize(file);
  }

  String generatePage(Book book, BookPage page) {
    final filename = page.filename;
    String _resolveFile(String f) {
      f = _toUrl(book, f);
      return p.relative(f, from: p.dirname(filename));
    }
    final engine = theme.buildEngine(
      lang: book.langPath,
      filters: <String, Function>{
        ..._builtinFilters,
        'resolveFile': _resolveFile,
      },
    );
    final data = _makePageRenderData(book, page);
    return engine.renderPage(data);
  }

  Map<String, dynamic> _makePageRenderData(Book book, BookPage page) {
    final summary = book.summary.json;

    final configData = _makeConfigData(book.config, book.langPath);
    final result = <String, dynamic>{
      ...book.pageJson(page),
      ...summary,
      ...configData,
      'glossary': {
      },
      'gitbook': {
      },
      'template': {
        'getJSContext': () => json.encode({
          ...book.pageJson(page, withContent: false),
          ...configData,
          'gitbook': {
          },
          'basePath': book.langPath.isEmpty ? '.' : '..',
          'book': {
            'language': book.language,
          },
        }),
      },
      'getPageByPath': (String path) {
        return book.pages[path];
      },
      ..._makePluginData(),
    };
    return result;
  }

  String lingualPage(BookContext context) {
    final engine = theme.buildEngine(
      lang: '',
      filters: _builtinFilters,
    );
    return engine.renderLingualIndex(_makeLingualIndexData(context));
  }

  Map<String, dynamic> _makeLingualIndexData(BookContext context) {
    final langMgr = context.langManager!;
    final config = context.config;
    final result = <String, dynamic>{
      'page': {
        'dir': '',
      },
      'gitbook': {
      },
      ..._makePluginData(),
      ..._makeConfigData(config, ''),
      ...langMgr.json,
    };
    return result;
  }

  Map<String, dynamic> _makeConfigData(BookConfig config, String lang) {
    return {
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
        'language': lang,
      },
    };
  }

  Map<String, dynamic> _makePluginData() {
    return {
      'plugins': {
        'resources': {
          'js': [],
          'css': [
          ]
        }
      },
    };
  }
}
