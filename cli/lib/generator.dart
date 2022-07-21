
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/page.dart';

import 'context.dart';
import 'template/template_engine.dart';

class Generator {
  final BookContext context;
  final TemplateEngine engine;

  Generator(this.context, this.engine);

  String generatePage(Book book, BookPage page) {
    final data = _makePageRenderData(book, page);
    return engine.renderPage(data);
  }

  Map<String, dynamic> _makePageRenderData(Book book, BookPage page) {
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

  String lingualPage(LanguageManager langMgr) {
    return engine.renderLingualIndex(_makeLingualIndexData(langMgr));
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
