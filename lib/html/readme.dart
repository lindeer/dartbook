import 'package:html/parser.dart' show parse;

class Readme {
  final String title;
  final String? desc;

  const Readme({required this.title, this.desc});

  static Readme from(String html) {
    final doc = parse(html);
    final headings = doc.getElementsByTagName('h1');
    final h1 = headings.isNotEmpty ? headings.first : null;
    final p = doc.querySelector('div.paragraph,p');
    return Readme(title: h1?.text.trim() ?? '', desc: p?.text.trim());
  }
}
