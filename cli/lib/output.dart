import 'dart:io' show File;

import 'package:dartbook/context.dart';
import 'package:dartbook_models/book.dart';
import 'package:html/parser.dart' as html;
import 'package:path/path.dart' as p;

import 'generator.dart';
import 'io.dart' show writeToFile, createFolder;
import 'modifiers.dart';
import 'theme_manager.dart';

class Option {
  /// format of generation, e.g. website, pdf
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
    createFolder(out);

    final theme = ThemeManager(
      layoutType: opt.format,
      dir: p.join(context.root, 'theme'),
    );
    final gen = Generator(
      theme: theme,
      directoryIndex: opt.directoryIndex,
    );
    final langMgr = context.langManager;
    for (final book in context.books.values) {
      final option = opt.copyWith(
        root: p.join(out, book.langPath),
      );
      final output = Output._(context, option);
      output.generatePages(gen, book);
    }

    final output = Output._(context, opt);
    if (langMgr != null) {
      final content = gen.lingualPage(context);
      File(p.join(out, 'index.html')).writeAsStringSync(content);
    }
    output.generateAssets();
    theme.copyAssets(p.join(out, 'gitbook'));

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
  }

  void generatePages(Generator generator, Book book) {
    final logger = context.logger;
    final pages = book.pages;
    final glossary = book.glossary;
    final gm = GlossaryModifier(glossary.items.values);

    for (final page in pages.values) {
      try {
        final filename = page.filename;
        page.content = _attachPageContent(p.join(book.bookPath, filename));
        if (page.content == null) {
          logger.w("Page '${book.filePath(filename)}' not exists!");
          continue;
        }
        final at = DateTime.now().millisecondsSinceEpoch;
        final outputName = book.outputName(filename);
        final raw = generator.generatePage(book, page);
        final doc = html.parse(raw);
        gm.annotate(book.outputName(page.filename), doc);
        writeToFile(p.join(opt.root, outputName), doc.outerHtml);

        final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
        final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
        logger.d("generate page '${p.join(book.langPath, page.filename)}' cost ${d.inSeconds}.${mills}s.");
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
      createFolder(p.dirname(to));
      File(from).copySync(to);
    }
  }
}
