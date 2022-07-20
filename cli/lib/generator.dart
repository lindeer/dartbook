
import 'dart:convert';
import 'dart:io' show File, Platform;

import 'package:dartbook/template/template_loader.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/page.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';
import 'package:path/path.dart' as p;

import 'context.dart';

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
}

typedef _GeneratorCreator = Generator Function(Options opt);

abstract class Generator {
  final String name;
  final Options opt;

  const Generator.__(this.name, this.opt);

  // TODO: prepare(BookContext context, Book book)
  void prepare(BookContext context, String bookKey);

  void generateAssets(Iterable<String> assets) {
  }

  void generatePages(Book book) {
  }

  void init(BookContext context, String bookKey);

  void finish(BookContext context, String bookKey);
}

class GeneratorFactory {
  final BookContext context;
  final Options opt;
  final Map<String, _GeneratorCreator> _factories;

  GeneratorFactory(this.context, this.opt)
      : _factories = <String, _GeneratorCreator> {
    'website' : (Options opt) => WebGenerator(context, opt),
  };

  Generator create({String? format, String? root, String? prefix, bool? index}) {
    final newOpt = Options(
      format: format ?? opt.format,
      root: root ?? opt.root,
      prefix: prefix ?? opt.prefix,
      directoryIndex: index ?? opt.directoryIndex,
    );
    return _factories[newOpt.format]!.call(newOpt);
  }
}

class WebGenerator extends Generator {
  final BookContext context;

  WebGenerator(this.context, Options opt) : super.__('website', opt);

  @override
  void prepare(BookContext context, String bookKey) {
  }

  @override
  void init(BookContext context, String bookKey) {
  }

  @override
  void finish(BookContext context, String bookKey) {
  }

  static _toOutputName(Book book, String filename) {
    final readme = book.readme;
    final base = p.basename(filename);
    final name = base == 'README' || readme.filename == filename
        ? p.normalize(p.join(p.dirname(filename), 'index.html'))
        : p.setExtension(filename, '.html');
    return name;
  }

  @override
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
    final pkgRoot = p.normalize(p.join(p.dirname(Platform.script.path), '..'));
    final layoutDir = '$pkgRoot/theme/_layouts';
    final prefix = opt.format;
    final env = Environment(
      filters: {
        'resolveAsset': (f) {
          final filepath = p.join('gitbook', f);
          return filepath;
        },
        'resolveFile': (f) => f,
        'contentURL': (path) => p.dirname(path),
        'fileExists': (f) => true,
        't': (id) => _i18n[id],
        // auto escape
        'safe': (f) => f,
        // JSON.stringify
        'dump': (f) => json.encode(f),
      },
      loader: TemplateLoader(
        {
          'layout.html': File('$layoutDir/layout.html').readAsStringSync(),
        },
        FileSystemLoader(
          path: '$layoutDir/$prefix',
        ),
      ),
    );
    final data = _makeBookRenderData(book, page);
    final result = env.getTemplate('page.html').render(data);
    out.writeAsStringSync(result);
  }

  Map<String, dynamic> _makeBookRenderData(Book book, BookPage page) {
    final config = context.config;

    final result = <String, dynamic>{
      'page': {
        'dir': page.dir,
        'content': page.content,
      },
      'summary': {
        'parts': [],
      },
      'glossary': {
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
}


const _i18n = <String, String>{
  "LANGS_CHOOSE": "选择一种语言",
  "GLOSSARY": "术语表",
  "GLOSSARY_INDEX": "索引",
  "GLOSSARY_OPEN": "术语表",
  "GITBOOK_LINK": "本书使用 GitBook 发布",
  "SUMMARY": "目录",
  "SUMMARY_INTRODUCTION": "介绍",
  "SUMMARY_TOGGLE": "目录",
  "SEARCH_TOGGLE": "搜索",
  "SEARCH_PLACEHOLDER": "输入并搜索",
  "FONTSETTINGS_TOGGLE": "字体设置",
  "SHARE_TOGGLE": "分享",
  "SHARE_ON": "分享到 {{platform}}",
  "FONTSETTINGS_WHITE": "白色",
  "FONTSETTINGS_SEPIA": "棕褐色",
  "FONTSETTINGS_NIGHT": "夜间",
  "FONTSETTINGS_SANS": "无衬线体",
  "FONTSETTINGS_SERIF": "衬线体"
};
