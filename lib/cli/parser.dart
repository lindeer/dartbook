
import 'package:dartbook/html/glossary.dart';
import 'package:dartbook/html/langs.dart';
import 'package:dartbook/html/page.dart';
import 'package:dartbook/html/readme.dart';
import 'package:dartbook/html/summary.dart';
import 'package:dartbook/models/book.dart';
import 'package:dartbook/models/page.dart';
import 'package:dartbook/models/parser.dart';
import 'package:markdown/markdown.dart' show Document, ExtensionSet, renderToHtml;

import 'logger.dart';

class MarkdownParser implements Parser {
  final Logger logger;
  final document = Document(extensionSet: ExtensionSet.gitHubFlavored);

  MarkdownParser(this.logger);

  @override
  String get name => 'markdown';

  @override
  Iterable<String> get ext => ['.md'];

  @override
  Iterable<Glossary> glossary(String content) => Glossary.from(_toHtml(content));

  @override
  Langs langs(String content) => Langs.from(_toHtml(content));

  @override
  Readme readme(String content) => Readme.from(_toHtml(content));

  @override
  Summary summary(String content) => Summary.from(_toHtml(content));

  @override
  Page page(String md) => Page(_toHtml(md));

  String _toHtml(String md) {
    final lines = md.replaceAll('\r\n', '\n').split('\n');
    // best safe way is to create a local document,
    // but reuse `document` to avoid creation mem objects.
    document.footnoteReferences.clear();
    document.footnoteLabels.clear();
    document.linkReferences.clear();
    final nodes = document.parseLines(lines);
    return '${renderToHtml(nodes)}\n';
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
