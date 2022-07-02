import 'dart:io' show Directory;

import 'package:dartbook_models/book.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';

class Output {
  final Generator generator;

  Output(this.generator);

  void generate(BookManager manager) {
    final out = generator.opt.root;
    final logger = manager.logger;
    logger.d('clean up folder: "$out"');
    final at = DateTime.now().millisecondsSinceEpoch;
    final folder = Directory(out);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    _process(manager);

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
  }

  void _process(BookManager manager) {
    final opt = generator.opt;
    final logger = manager.logger;
    final langKeys = manager.langManager?.items.keys ?? [""];
    for (final k in langKeys) {
      final lang = manager.langManager?[k];
      final gen = lang == null ? generator
          : Generator(generator.name, opt.copyWith(
        root: p.join(opt.root, lang.path),
      ));
      logger.i('generate ${lang == null ? "normal" : "language [${lang.title}]"} book');

      gen.prepare(manager, k);

      _invokeHook('init', manager);
      gen.init(manager, k);

      _invokeHook('finish:before', manager);
      gen.finish(manager, k);

      _invokeHook('finish', manager);
    }
  }

  void _invokeHook(String name, BookManager manager) {
  }
}