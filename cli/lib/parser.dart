
import 'dart:io' show File;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook_html/glossary.dart';
import 'package:dartbook_html/langs.dart';
import 'package:dartbook_html/readme.dart';
import 'package:dartbook_html/summary.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/glossary.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/page.dart';
import 'package:dartbook_models/parser.dart';
import 'package:dartbook_models/part.dart';
import 'package:dartbook_models/readme.dart';
import 'package:dartbook_models/summary.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;

import 'logger.dart';

class MarkdownParser implements Parser {
  final Logger logger;

  MarkdownParser(this.logger);

  @override
  String get name => 'markdown';

  @override
  Iterable<String> get ext => ['.md'];

  @override
  BookGlossary glossary(String filePath) {
    final file = File(filePath);
    final glossary = Glossary.from(markdownToHtml(file.readAsStringSync()));
    final items = glossary.map((e) {
      return GlossaryItem(e.name, desc: e.desc);
    });
    return BookGlossary.fromItems(file.path, items);
  }

  @override
  LanguageManager langs(String filePath) {
    final file = File(filePath);
    final langs = Langs.from(markdownToHtml(file.readAsStringSync()));
    final items = langs.articles.map((e) {
      return BookLanguage(e.title, e.ref!);
    });
    return LanguageManager.create(file.path, items);
  }

  @override
  BookReadme readme(String filePath) {
    final file = File(filePath);
    final readme = Readme.from(markdownToHtml(file.readAsStringSync()));
    return BookReadme(
      filename: file.path,
      title: readme.title,
      desc: readme.desc,
    );
  }

  @override
  BookSummary summary(String filePath) {
    final file = File(filePath);
    final summary = Summary.from(markdownToHtml(file.readAsStringSync()));
    final len = summary.parts.length;
    final parts = summary.parts.mapIndexed((i, part) {
      final level = len > 1 ? '${i + 1}' : '';
      return SummaryPart.create(part, level);
    });
    return BookSummary(file.path, parts.toList(growable: false));
  }

  @override
  BookPage page(String filePath) {
    final file = File(filePath);
    final content = markdownToHtml(file.readAsStringSync());
    return BookPage(filename: file.path, content: content);
  }

  @override
  Iterable<String> assets() {
    return [];
  }

  @override
  void pages(Book book) {
    final summary = book.summary;
    final all = <String, BookPage>{};
    summary.walk((article) {
      final path = article.path;
      if (path != null) {
        all[path] = BookPage(filename: path);
      } else {
        logger.w("path of article '${article.title}' is null!");
      }
    });
    book.pages..clear()..addAll(all);
  }
}
