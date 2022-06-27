import 'package:html/parser.dart' show parse;

Map<String, String?> readme(String html) {
  final doc = parse(html);
  final headings = doc.getElementsByTagName('h1');
  final h1 = headings.isNotEmpty ? headings.first : null;
  final p = doc.querySelector('div.paragraph,p');
  return {
    "title": h1?.text.trim(),
    "description": p?.text.trim(),
  };
}
