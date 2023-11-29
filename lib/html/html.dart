
import 'package:html/parser.dart' show parse;

class Extractor {

  static ({String title, String? desc}) readme(String html) {
    final doc = parse(html);
    final headings = doc.getElementsByTagName('h1');
    final h1 = headings.isNotEmpty ? headings.first : null;
    final p = doc.querySelector('div.paragraph,p');
    return (title: h1?.text.trim() ?? '', desc: p?.text.trim());
  }

  static Iterable<({String name, String? desc})> glossary(String html) {
    final doc = parse(html);
    return doc.getElementsByTagName('h2').map((h2) {
      final next = h2.nextElementSibling;
      final p = next?.localName == 'p' ? next : next?.getElementsByTagName('p').firstOrNull;
      return (name: h2.text.trim(), desc: p?.innerHtml);
    });
  }
}
