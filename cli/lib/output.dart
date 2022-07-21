import 'dart:io' show Directory, File;

import 'package:dartbook/context.dart';
import 'package:dartbook_models/book.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';
import 'theme_manager.dart';

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
    final gen = Generator(context, engine);
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

    if (langMgr != null) {
      final content = gen.lingualPage(langMgr);
      File(p.join(opt.root, 'index.html')).writeAsStringSync(content);
    }

    final d = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - at);
    final mills = d.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    logger.i('generation finished with success in ${d.inSeconds}.${mills}s.');
  }

  static String _toOutputName(Book book, String filename) {
    final readme = book.readme;
    final base = p.basename(filename);
    final name = base == 'README' || readme.filename == filename
        ? p.normalize(p.join(p.dirname(filename), 'index.html'))
        : p.setExtension(filename, '.html');
    return name;
  }

  void generatePages(Generator generator, Book book) {
    final logger = context.logger;
    final pages = book.pages;
    for (final page in pages.values) {
      try {
        final filename = page.filename;
        page.content = _attachPageContent(p.join(book.root, filename));
        final outputName = _toOutputName(book, filename);
        _generatePage(outputName, generator.generatePage(book, page));
      } on Exception catch (e) {
        logger.d("generate page '${page.filename}' failed by ${e.toString()}, ignored.");
      }
    }
  }

  String? _attachPageContent(String filePath) {
    final parser = context.parser;
    final htmlPage = parser.page(File(filePath).readAsStringSync());
    return htmlPage.content;
  }

  void _generatePage(String outputName, String result) {
    final out = File(p.join(opt.root, outputName));
    if (!out.parent.existsSync()) {
      out.createSync(recursive: true);
    }
    out.writeAsStringSync(result);
  }
}
