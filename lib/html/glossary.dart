import 'package:html/parser.dart' show parse;

List<Map<String, String?>> glossary(String html) {
  final doc = parse(html);
  return doc.getElementsByTagName('h2').map((h2) {
    final next = h2.nextElementSibling;
    final p = next?.localName == 'p' ? next
        : next?.getElementsByTagName('p').first;
    return {
      "name": h2.text.trim(),
      "description": p?.text.trim(),
    };
  }).toList(growable: false);
}
