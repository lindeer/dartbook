
import 'dart:convert' show json;
import 'dart:io' show File;

import 'package:dartbook/models/book.dart';
import 'package:dartbook/models/config.dart';
import 'package:dartbook/models/page.dart';
import 'package:html/parser.dart' as html;
import 'package:path/path.dart' as p;

import 'context.dart';
import 'modifiers.dart';
import 'template/template_engine.dart' show RenderContext;
import 'theme_manager.dart';

extension _PathExt on String {

  String pathTo(String target) => p.relative(target, from: p.dirname(this));

}

class Generator {
  final Book book;
  final GlossaryModifier modifier;
  final bool directoryIndex;

  factory Generator({
    required Book book,
    required bool directoryIndex,
  }) {
    final glossary = book.glossary;
    final gm = GlossaryModifier(glossary.items.values);
    return Generator._(book, gm, directoryIndex);
  }

  const Generator._(this.book, this.modifier, this.directoryIndex);

  static final _builtinFilters = <String, Function>{
    'contentURL': (path) => p.dirname(path),
  };

  String _toUrl(String filename) {
    if (filename.startsWith('/')) {
      filename = filename.substring(1);
    }
    String file = File(book.fileFsPath(filename)).existsSync()
        ? book.outputName(filename)
        : filename;
    if (directoryIndex && p.basename(file) == 'index.html') {
      file = p.dirname(file);
    }
    return p.normalize(file);
  }

  String generatePage(ThemeManager theme, BookPage page) {
    final filename = page.filename;
    final filePath = book.filePath(filename);
    final engine = theme.engine;
    final data = RenderContext(
      filters: {
        ...theme.builtinFilters,
        ..._builtinFilters,
        'resolveAsset': (String f) => filePath.pathTo(p.join('dartbook', f)),
        'resolveFile': (String f) => filename.pathTo(_toUrl(f)),
        'fileExists': (String f) => File(book.fileFsPath(f)).existsSync(),
      },
      data: _makePageRenderData(page),
    );
    final raw = engine.renderPage(data);
    final doc = html.parse(raw);
    addHeadingId(doc);
    modifier.annotate(doc);
    return doc.outerHtml;
  }

  Map<String, dynamic> _makePageRenderData(BookPage page) {
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
        'resolveAsset': (f) => p.join('dartbook', f),
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
            'showLevel': true,
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
