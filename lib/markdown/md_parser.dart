library dartbook.markdown;

import 'package:dartbook/html/glossary.dart';
import 'package:dartbook/html/langs.dart';
import 'package:dartbook/html/page.dart';
import 'package:dartbook/html/readme.dart';
import 'package:dartbook/html/summary.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;

class MdParser {

  Langs langs(String md) => Langs.from(markdownToHtml(md));

  Readme readme(String md) => Readme.from(markdownToHtml(md));

  Iterable<Glossary> glossary(String md) => Glossary.from(markdownToHtml(md));

  Summary summary(String md) => Summary.from(markdownToHtml(md));

  Page page(String md) => Page(markdownToHtml(md));
}
