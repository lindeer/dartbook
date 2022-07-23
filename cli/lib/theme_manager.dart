import 'dart:convert' show json;
import 'dart:io' show Directory, File, FileSystemEntity, Link, Platform;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:jinja/jinja.dart' show Environment, Loader;
import 'package:jinja/loaders.dart' show FileSystemLoader;
import 'package:path/path.dart' as p;
import 'template/template_engine.dart';
import 'template/template_loader.dart';

import 'io.dart' as io;

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
  final String? themeDir;
  final _innerThemeDir = p.normalize(p.join(
      p.dirname(Platform.script.path), '..', 'theme'));
  final _cacheStringRes = <String, Map<String, dynamic>>{};
  Loader? _cacheLoader;

  ThemeManager({
    required this.layoutType,
    /// default theme dir is 'theme' in book directory, symbol link is also supported
    String? dir,
  }): themeDir = dir != null && _isDirectory(dir) ? dir : null;

  TemplateEngine buildEngine({
    required String lang,
    String? path,
    Map<String, Function>? filters,
  }) {
    final loader = (_cacheLoader ??= _makeLoader(path));
    final i18n = (_cacheStringRes[lang] ??= _makeStringRes(lang));
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

  Loader _makeLoader(String? path) {
    final parent = File(p.join(_innerThemeDir, '_layouts', 'layout.html')).readAsStringSync();
    final d = themeDir;
    return TemplateLoader(
      {
        'layout.html': parent,
      },
      FileSystemLoader(
        paths: [
          if (path != null)
            path,
          if (d != null)
            p.join(d, '_layouts', layoutType),
          p.join(_innerThemeDir, '_layouts', layoutType),
        ],
      ),
    );
  }

  Map<String, String> _makeStringRes(String lang) {
    lang = lang.length > 1 ? lang : 'en';
    final file = File(p.join(_innerThemeDir, '_i18n', '$lang.html'));
    final f = file.existsSync() ? file : File(_similarI18n(lang));
    final res = json.decode(f.readAsStringSync()).cast<String, String>();
    final d = themeDir;
    if (d != null) {
      final file = File(p.join(d, '_i18n', '$lang.html'));
      if (file.existsSync()) {
        final override = json.decode(file.readAsStringSync()).cast<String, String>();
        res.addAll(override);
      }
    }
    return res;
  }

  String _similarI18n(String lang)  {
    final dir = Directory(p.join(_innerThemeDir, '_i18n'));
    final names = dir.listSync(recursive: false)
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
