import 'dart:convert' show json;
import 'dart:io' show Directory, File, Platform;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:jinja/jinja.dart' show Environment, Loader;
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
  Map<String, dynamic>? _cacheStringRes;
  Loader? _cacheLoader;

  ThemeManager({
    required this.lang,
    required this.layoutType,
    this.themeDir,
  });

  TemplateEngine buildEngine({
    String? path,
    Map<String, Function>? filters,
  }) {
    final loader = (_cacheLoader ??= _makeLoader(path));
    final i18n = (_cacheStringRes ??= _makeStringRes());
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
    final parent = File('$_innerThemeDir/_layouts/layout.html').readAsStringSync();
    return TemplateLoader(
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
  }

  Map<String, String> _makeStringRes() {
    final file = File('$_innerThemeDir/_i18n/$lang.html');
    final f = file.existsSync() ? file : File(_similarI18n);
    final res = json.decode(f.readAsStringSync()).cast<String, String>();
    if (themeDir != null) {
      final file = File('$themeDir/_i18n/$lang.html');
      if (file.existsSync()) {
        final override = json.decode(file.readAsStringSync()).cast<String, String>();
        res.addAll(override);
      }
    }
    return res;
  }

  String get _similarI18n {
    final dir = Directory('$_innerThemeDir/_i18n');
    final names = dir.listSync(recursive: false)
        .map((e) => p.relative(e.path, from: dir.path));
    final prefix = lang.length > 2 ? lang.substring(0, 2) : lang;
    final filter = names.where((s) => s.substring(0, 2) == prefix);
    final filename = filter.firstOrNull ?? 'en.json';
    return p.join(dir.path, filename);
  }
}
