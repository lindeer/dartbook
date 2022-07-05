
import 'dart:io' show File;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook_markdown/md_parser.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/glossary.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/page.dart';
import 'package:dartbook_models/part.dart';
import 'package:dartbook_models/readme.dart';
import 'package:dartbook_models/summary.dart';

import 'logger.dart';

abstract class ContentParser {

  LanguageManager langs(File file);

  BookReadme readme(File file);

  BookSummary summary(File file);

  BookGlossary glossary(File file);

  void pages(Book book);

  Iterable<String> assets(Book book);
}

class MarkdownParser extends ContentParser {
  final Logger logger;
  final _parser = MdParser();

  MarkdownParser(this.logger);

  @override
  BookGlossary glossary(File file) {
    final glossary = _parser.glossary(file.readAsStringSync());
    final items = glossary.map((e) {
      return GlossaryItem(e.name, desc: e.desc);
    });
    return BookGlossary.fromItems(file.path, items);
  }

  @override
  LanguageManager langs(File file) {
    final langs = _parser.langs(file.readAsStringSync());
    final items = langs.articles.map((e) {
      return BookLanguage(e.title, e.ref!);
    });
    return LanguageManager.create(file.path, items);
  }

  @override
  BookReadme readme(File file) {
    final readme = _parser.readme(file.readAsStringSync());
    return BookReadme(
      filename: file.path,
      title: readme.title,
      desc: readme.desc,
    );
  }

  @override
  BookSummary summary(File file) {
    final summary = _parser.summary(file.readAsStringSync());
    final len = summary.parts.length;
    final parts = summary.parts.mapIndexed((i, part) {
      final level = len > 1 ? '${i + 1}' : '';
      return SummaryPart.create(part, level);
    });
    return BookSummary(file.path, parts.toList(growable: false));
  }

  @override
  Iterable<String> assets(Book book) {
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
