import 'dart:io' show Directory, File, Platform;

import 'package:dartbook/context.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart' show FileSystemLoader;
import 'package:path/path.dart' as p;

import 'generator.dart';
import 'template/template_loader.dart';

class Output {
  final GeneratorFactory factory;

  Output(this.factory);

  void generate() {
    final context = factory.context;
    final out = factory.opt.root;
    final logger = context.logger;
    logger.d('clean up folder: "$out"');
    final at = DateTime.now().millisecondsSinceEpoch;
    final folder = Directory(out);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    _process(context);

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
  }

  void _process(BookContext context) {
    final opt = factory.opt;
    final logger = context.logger;
    final langKeys = context.langManager?.items.keys ?? [""];
    for (final k in langKeys) {
      final lang = context.langManager?[k];
      final gen = lang == null ? factory.create()
          : factory.create(
        root: p.join(opt.root, lang.path),
      );
      logger.i('generate ${lang == null ? "normal" : "language [${lang.title}]"} book');

      final book = context[k]!;
      gen.prepare(context, k);

      _invokeHook('init', context);
      gen.init(context, k);

      gen.generatePages(book);

      _invokeHook('finish:before', context);
      gen.finish(context, k);

      _invokeHook('finish', context);
    }
    final gen = factory.create();
    final assets = context.listAssets();
    gen.generateAssets(assets);

    _onFinish();
  }

  void _invokeHook(String name, BookContext context) {
  }

  void _onFinish() {
    final context = factory.context;
    if (!context.isMultilingual) {
      return;
    }

    final opt = factory.opt;
    final pkgRoot = p.normalize(p.join(p.dirname(Platform.script.path), '..'));
    final prefix = opt.format;
    final dir = '$pkgRoot/theme/_layouts';

    final env = Environment(
      filters: {
        'resolveAsset': (f) => '/$f',
        'resolveFile': (f) => '/$f',
        'contentURL': (url) => url,
        'fileExists': (f) => true,
        't': (id) => i18n[id],
        'safe': (f) => f,
        'dump': (f) => f,
      },
      loader: TemplateLoader(
        {
          'layout.html': File('$dir/layout.html').readAsStringSync(),
        },
        FileSystemLoader(
          path: '$dir/$prefix',
        ),
      ),
    );
    const filename = 'index.html';
    final template = env.getTemplate('languages.html');
    final data = _makeLanguageManagerData();
    final result = template.render(data);

    final outRoot = opt.root;
    final outFile = p.join(outRoot, filename);
    File(outFile).writeAsStringSync(result);
  }

  Map<String, dynamic> _makeLanguageManagerData() {
    final context = factory.context;
    final config = context.config;
    final result = <String, dynamic>{
      'page': {
      },
      'gitbook': {
      },
      'template': {
        'getJSContext': () {
          return {};
        }
      },
      'getPageByPath': (path) {
        return true;
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
      'language': 'en'
    });
    result['config'] = conf;
    final langs = context.langManager;
    if (langs != null) {
      result.addAll(langs.json);
    }
    return result;
  }
}


const i18n = <String, String>{
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
