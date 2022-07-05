import 'dart:io' show Directory;

import 'package:dartbook/context.dart';
import 'package:dartbook_models/book.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';

class Output {
  final AppContext context;
  final BookManager manager;
  final GeneratorFactory factory;

  Output(this.context, this.manager, this.factory);

  void generate() {
    final out = factory.opt.root;
    final logger = context.logger;
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
    final opt = factory.opt;
    final logger = context.logger;
    final langKeys = manager.langManager?.items.keys ?? [""];
    for (final k in langKeys) {
      final lang = manager.langManager?[k];
      final gen = lang == null ? factory.create()
          : factory.create(
        root: p.join(opt.root, lang.path),
      );
      logger.i('generate ${lang == null ? "normal" : "language [${lang.title}]"} book');

      final book = manager[k]!;
      final parser = context.parser;
      final pages = parser.pages(manager, book);
      final assets = parser.assets(manager, book);
      gen.prepare(manager, k);

      _invokeHook('init', manager);
      gen.init(manager, k);

      gen.generateAssets(manager, assets);
      gen.generatePages(book, pages);

      _invokeHook('finish:before', manager);
      gen.finish(manager, k);

      _invokeHook('finish', manager);
    }
  }

  void _invokeHook(String name, BookManager manager) {
  }
}
