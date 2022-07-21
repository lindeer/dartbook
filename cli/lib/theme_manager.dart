import 'dart:io' show File, Platform;

import 'package:jinja/jinja.dart' show Environment;
import 'package:jinja/loaders.dart' show FileSystemLoader;
import 'package:path/path.dart' as p;
import 'template/template_engine.dart';
import 'template/template_loader.dart';

class ThemeManager {
  final String lang;
  final String layoutType;
  final String? themeDir;
  final _innerThemeDir = p.normalize(p.join(
      p.dirname(Platform.script.path), '../theme'));

  ThemeManager({
    required this.lang,
    required this.layoutType,
    this.themeDir,
  });

  TemplateEngine buildEngine({
    String? path,
    Map<String, Function>? filters,
  }) {
    final parent = File('$_innerThemeDir/_layouts/layout.html').readAsStringSync();
    final loader = TemplateLoader(
      {
        'layout.html': parent,
      },
      FileSystemLoader(
        paths: [
          if (path != null)
            path,
          if (themeDir != null)
            '$themeDir/_layouts/$layoutType',
          '$_innerThemeDir/_layouts/$layoutType',
        ],
      ),
    );
    final env = Environment(
      loader: loader,
      filters: <String, Function>{
        'safe': (f) => f,
        'dump': (f) => f,
        't': (id) => i18n[id],
        if (filters != null)
          ...filters,
      },
    );
    return TemplateEngine(env);
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
