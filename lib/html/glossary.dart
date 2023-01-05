library dartbook.html;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:html/parser.dart' show parse;

class Glossary {
  final String name;
  final String? desc;

  const Glossary({required this.name, this.desc});

  static Iterable<Glossary> from(String html) {
    final doc = parse(html);
    return doc.getElementsByTagName('h2').map((h2) {
      final next = h2.nextElementSibling;
      final p = next?.localName == 'p' ? next : next?.getElementsByTagName('p').firstOrNull;
      return Glossary(name: h2.text.trim(), desc: p?.innerHtml);
    });
  }
}
