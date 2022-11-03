
import 'dart:convert' show json;
import 'dart:io' show File;

import 'package:dartbook/template/template_engine.dart' show RenderContext;
import 'package:dartbook/theme_manager.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/config.dart';
import 'package:dartbook_models/page.dart';
import 'package:path/path.dart' as p;

import 'context.dart';

class Generator {
  final bool directoryIndex;

  Generator({
    required this.directoryIndex,
  });

  final _builtinFilters = <String, Function>{
    'resolveAsset': (f) {
      final filepath = p.join('/gitbook', f);
      return filepath;
    },
    'contentURL': (path) => p.dirname(path),
  };

  String _toUrl(Book book, String filename) {
    if (filename.startsWith('/')) {
      filename = filename.substring(1);
    }
    String file = File(book.filePath(filename)).existsSync()
        ? book.outputName(filename)
        : filename;
    if (directoryIndex && p.basename(file) == 'index.html') {
      file = p.dirname(file);
    }
    return p.normalize(file);
  }

  String generatePage(ThemeManager theme, Book book, BookPage page) {
    final filename = page.filename;
    final engine = theme.engine;
    final data = RenderContext(
      filters: {
        ...theme.builtinFilters,
        ..._builtinFilters,
        'resolveFile': (String f) {
          f = _toUrl(book, f);
          return p.relative(f, from: p.dirname(filename));
        },
        'fileExists': (String f) => File(book.filePath(f)).existsSync(),
      },
      data: _makePageRenderData(book, page),
    );
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

  String lingualPage(ThemeManager theme, BookContext context) {
    final render = RenderContext(
      filters: {
        ...theme.builtinFilters,
        ..._builtinFilters,
      },
      data: _makeLingualIndexData(context),
    );
    return theme.engine.renderLingualIndex(render);
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
        'styles': config['styles'] ?? <String, String>{},
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
