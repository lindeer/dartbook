import 'dart:io' show Directory, File;

import 'package:dartbook/context.dart';
import 'package:dartbook_models/book.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';
import 'theme_manager.dart';
import 'io.dart' show writeToFile;

class Option {
  final String format;
  /// Root folder for the output
  final String root;
  /// Prefix for generation
  final String? prefix;
  /// Use directory index url instead of "index.html"
  final bool directoryIndex;

  const Option({
    required this.format,
    required this.root,
    this.prefix,
    this.directoryIndex = true,
  });

  Option copyWith({String? format, String? root, String? prefix, bool? index}) {
    return Option(
      format: format ?? this.format,
      root: root ?? this.root,
      prefix: prefix ?? this.prefix,
      directoryIndex: index ?? directoryIndex,
    );
  }
}

/// IO operations of generation
class Output {
  final BookContext context;
  final Option opt;

  const Output._(this.context, this.opt);

  static void generate(BookContext context, Option opt) {
    final out = opt.root;
    final logger = context.logger;
    logger.d('generate whole book in "$out"');
    final at = DateTime.now().millisecondsSinceEpoch;
    final folder = Directory(out);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    final theme = ThemeManager(
      lang: 'zh',
      layoutType: opt.format,
      dir: p.join(context.root, 'theme'),
    );
    final gen = Generator(
      theme: theme,
      directoryIndex: opt.directoryIndex,
    );
    final langMgr = context.langManager;
    final keys = langMgr?.items.keys ?? [''];
    for (final lang in keys) {
      final item = langMgr?.items[lang];
      final book = context[lang]!;
      final option = item == null ? opt : opt.copyWith(
        root: p.join(opt.root, item.path),
      );
      final output = Output._(context, option);
      output.generatePages(gen, book);
    }

    final output = Output._(context, opt);
    if (langMgr != null) {
      final content = gen.lingualPage(context);
      File(p.join(opt.root, 'index.html')).writeAsStringSync(content);
    }
    output.generateAssets();
    theme.copyAssets(p.join(opt.root, 'gitbook'));

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
  }

  void generatePages(Generator generator, Book book) {
    final logger = context.logger;
    final pages = book.pages;
    for (final page in pages.values) {
      try {
        final filename = page.filename;
        page.content = _attachPageContent(p.join(book.bookPath, filename));
        if (page.content == null) {
          logger.w("Page '${book.filePath(filename)}' not exists!");
          continue;
        }
        final outputName = book.outputName(filename);
        writeToFile(p.join(opt.root, outputName), generator.generatePage(book, page));
      } on Exception catch (e) {
        logger.d("generate page '${page.filename}' failed by ${e.toString()}, ignored.");
      }
    }
  }

  String? _attachPageContent(String filePath) {
    final parser = context.parser;
    final file = File(filePath);
    if (!file.existsSync()) {
      return null;
    }
    final htmlPage = parser.page(file.readAsStringSync());
    return htmlPage.content;
  }

  void generateAssets() {
    final root = context.root;
    final out = opt.root;
    final files = context.listAssets(relative: true);
    for (final file in files) {
      final from = p.join(root, file);
      final to = p.join(out, file);
      File(from).copySync(to);
    }
  }
}
