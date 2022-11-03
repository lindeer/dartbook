import 'dart:async' show Timer;
import 'dart:io' show File;

import 'package:dartbook/context.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/page.dart';
import 'package:html/parser.dart' as html;
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart' show WatchEvent;

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
  final ThemeManager theme;
  final Generator generator;
  final _pageGenerator = <String, void Function(BookPage page)>{};

  Output._(this.context, this.theme, this.generator);

  static Output generate(BookContext context, Option opt) {
    final out = opt.root;
    final logger = context.logger;
    logger.d('generate whole book in "$out"');
    final at = DateTime.now().millisecondsSinceEpoch;
    createFolder(out);

    for (final book in context.books.values) {
      final output = Output._(
        context,
        ThemeManager.build(
          layoutType: opt.format,
          lang: book.langPath,
          dir: p.join(context.root, 'theme'),
        ),
        Generator(
          directoryIndex: opt.directoryIndex,
        ),
      );
      output.generatePages(book, p.join(out, book.langPath));
    }

    final theme = ThemeManager.build(
      layoutType: opt.format,
      lang: 'en',
      dir: p.join(context.root, 'theme'),
    );
    final gen = Generator(
      directoryIndex: opt.directoryIndex,
    );
    final output = Output._(context, theme, gen);
    final langMgr = context.langManager;
    if (langMgr != null) {
      final content = gen.lingualPage(theme, context);
      File(p.join(out, 'index.html')).writeAsStringSync(content);
    }
    output.generateAssets(out);
    theme.copyAssets(p.join(out, 'gitbook'));

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
    return output;
  }

  void generatePages(Book book, String out) {
    final logger = context.logger;
    final pages = book.pages;
    final glossary = book.glossary;
    final gm = GlossaryModifier(glossary.items.values);

    void _outputPage(BookPage page) {
      final filename = page.filename;
      page.content = _attachPageContent(p.join(book.bookPath, filename));
      if (page.content == null) {
        logger.w("Page '${book.filePath(filename)}' not exists!");
        return;
      }

      final raw = generator.generatePage(theme, book, page);
      final doc = html.parse(raw);
      addHeadingId(doc);
      gm.annotate(doc);
      final outputName = book.outputName(page.filename);
      writeToFile(p.join(out, outputName), doc.outerHtml);
      page.content = null;
    }

    for (final page in pages.values) {
      try {
        final at = DateTime.now().millisecondsSinceEpoch;
        _outputPage(page);

        final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
        final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
        logger.d("generate page '${p.join(book.langPath, page.filename)}' cost ${d.inSeconds}.${mills}s.");
      } on Exception catch (e) {
        logger.d("generate page '${page.filename}' failed by ${e.toString()}, ignored.");
      }
    }

    _pageGenerator[book.langPath] = _outputPage;
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

  void generateAssets(String out) {
    final root = context.root;
    final files = context.listAssets(relative: true);
    for (final file in files) {
      final from = p.join(root, file);
      final to = p.join(out, file);
      createFolder(p.dirname(to));
      File(from).copySync(to);
    }
  }

  Timer? _regenerateAction;

  void onFileChanged(WatchEvent e) {
    final path = e.path;
    final logger = context.logger;
    for (final book in context.books.values) {
      if (!p.isWithin(book.bookPath, path)) {
        continue;
      }

      final filename = p.relative(path, from: book.bookPath);
      final page = book.pages[filename];
      final gen = _pageGenerator[book.langPath];
      if (page == null || gen == null) {
        logger.w("invalid '$filename', some thing wrong with app");
        continue;
      }
      _regenerateAction?.cancel();
      _regenerateAction = Timer(Duration(milliseconds: 800), () {
        gen.call(page);
        logger.i("regenerate page '$filename' done.");
        _regenerateAction = null;
      });
    }
  }
}
