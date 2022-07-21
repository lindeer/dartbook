import 'dart:io' show Directory;

import 'package:dartbook/context.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';
import 'theme_manager.dart';

class Output {
  final Options opt;

  const Output(this.opt);

  void generate(BookContext context) {
    final out = opt.root;
    final logger = context.logger;
    logger.d('clean up folder: "$out"');
    final at = DateTime.now().millisecondsSinceEpoch;
    final folder = Directory(out);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    final theme = ThemeManager(lang: 'zh', layoutType: opt.format);
    final engine = theme.buildEngine(
      filters: <String, Function>{
        'resolveAsset': (f) {
          final filepath = p.join('gitbook', f);
          return filepath;
        },
        'resolveFile': (f) => f,
        'contentURL': (path) => p.dirname(path),
        'fileExists': (f) => true,
      },
    );
    final langMgr = context.langManager;
    final keys = langMgr?.items.keys ?? [''];
    for (final lang in keys) {
      final item = langMgr?.items[lang];
      final book = context[lang]!;
      final option = item == null ? opt : opt.copyWith(
        root: p.join(opt.root, item.path),
      );
      final gen = Generator(option, context, engine);
      gen.generatePages(book);
    }

    if (langMgr != null) {
      final gen = Generator(opt, context, engine);
      gen.lingualIndex(langMgr);
    }

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
  }
}
