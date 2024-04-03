library theme;

import 'dart:convert' show json;
import 'dart:io' show Directory, File, FileSystemEntity, Link;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:jinja/jinja.dart' show Environment, Loader;
import 'package:jinja/loaders.dart' show FileSystemLoader;
import 'package:path/path.dart' as p;

import 'io.dart' as io;
import 'template/template_engine.dart';
import 'template/template_loader.dart';

part 'src/jinja_template.dart';

bool _isDirectory(String dir) {
  if (FileSystemEntity.isDirectorySync(dir)) {
    return true;
  }
  if (FileSystemEntity.isLinkSync(dir)) {
    final link = Link(dir).resolveSymbolicLinksSync();
    return FileSystemEntity.isDirectorySync(link);
  }
  return false;
}

/// load theme resources from _assets, _i18n, _layouts
class ThemeManager {
  final String layoutType;
  final String _innerThemeDir;
  final TemplateEngine engine;
  final Map<String, Function> builtinFilters;
  final String? themeDir;

  static ThemeManager build({
    required String assetDir,
    required String layoutType,
    required String lang,
    String? path,
    String? dir,
  }) {
    final inner = assetDir;
    final themeDir = dir != null && _isDirectory(dir) ? dir : null;
    final loader = _makeLoader(inner, layoutType, themeDir, path);
    final i18n = _makeStringRes(inner, themeDir, lang);
    final env = Environment(
      loader: loader,
      filters: <String, Function>{
        'safe': (f) => f,
        'dump': (f) => f,
        't': (id) => i18n[id],
      },
    );
    final builtinFilters = Map.of(env.filters);
    env.filters.clear();
    return ThemeManager._(
      layoutType,
      inner,
      _JinjaTemplate(env),
      builtinFilters,
      themeDir,
    );
  }

  const ThemeManager._(
    this.layoutType,
    this._innerThemeDir,
    this.engine,
    this.builtinFilters,
    this.themeDir,
  );

  static Loader _makeLoader(
    String themeDir,
    String layoutType,
    String? userDir,
    String? path,
  ) {
    final filepath = p.join(themeDir, '_layouts', 'layout.html');
    final parent = File(filepath).readAsStringSync();
    final d = userDir;
    return TemplateLoader(
      {
        'layout.html': parent,
      },
      FileSystemLoader(
        paths: [
          if (path != null) path,
          if (d != null) p.join(d, '_layouts', layoutType),
          p.join(themeDir, '_layouts', layoutType),
        ],
      ),
    );
  }

  static Map<String, String> _makeStringRes(
    String themeDir,
    String? userDir,
    String lang,
  ) {
    lang = lang.length > 1 ? lang : 'en';
    final file = File(p.join(themeDir, '_i18n', '$lang.html'));
    final f = file.existsSync() ? file : File(_similarI18n(themeDir, lang));
    final res = json.decode(f.readAsStringSync()).cast<String, String>();
    if (userDir != null) {
      final uf = File(p.join(userDir, '_i18n', '$lang.html'));
      if (uf.existsSync()) {
        final str = uf.readAsStringSync();
        final override = json.decode(str).cast<String, String>();
        res.addAll(override);
      }
    }
    return res;
  }

  static String _similarI18n(String themeDir, String lang) {
    final dir = Directory(p.join(themeDir, '_i18n'));
    final names = dir
        .listSync(recursive: false)
        .map((e) => p.relative(e.path, from: dir.path));
    final prefix = lang.length > 1 ? lang.substring(0, 2) : lang;
    final filter = names.where((s) => s.substring(0, 2) == prefix);
    final filename = filter.firstOrNull ?? 'en.json';
    return p.join(dir.path, filename);
  }

  void copyAssets(String to) {
    io.copyPathSync(p.join(_innerThemeDir, '_assets', layoutType), to);
    final d = themeDir;
    final from = d != null ? p.join(d, '_assets', layoutType) : null;
    if (from != null) {
      io.copyPathSync(from, to);
    }
  }
}
