import 'dart:io' show Directory;

import 'package:dartbook/context.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';

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
      final parser = context.parser;
      final assets = parser.assets(book);
      gen.prepare(context, k);

      _invokeHook('init', context);
      gen.init(context, k);

      gen.generateAssets(context, assets);
      gen.generatePages(book);

      _invokeHook('finish:before', context);
      gen.finish(context, k);

      _invokeHook('finish', context);
    }
  }

  void _invokeHook(String name, BookContext context) {
  }
}
