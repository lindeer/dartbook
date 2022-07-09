
import 'package:dartbook_html/glossary.dart';
import 'package:dartbook_html/langs.dart';
import 'package:dartbook_html/page.dart';
import 'package:dartbook_html/readme.dart';
import 'package:dartbook_html/summary.dart';
import 'package:dartbook_models/book.dart';
import 'package:dartbook_models/page.dart';
import 'package:dartbook_models/parser.dart';
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
  Iterable<Glossary> glossary(String content) => Glossary.from(markdownToHtml(content));

  @override
  Langs langs(String content) => Langs.from(markdownToHtml(content));

  @override
  Readme readme(String content) => Readme.from(markdownToHtml(content));

  @override
  Summary summary(String content) => Summary.from(markdownToHtml(content));

  @override
  Page page(String md) => Page(markdownToHtml(md));

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
