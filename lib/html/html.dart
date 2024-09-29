library dartbook.html;

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Element;

const _listSelector = 'ol, ul';
const _partSelector = 'h2, h3, h4';

/// A link reference object for pure html raw text.
class Article {
  final String title;
  final String? ref;
  final Iterable<Article>? articles;

  const Article({
    required this.title,
    this.ref,
    this.articles,
  });

  static Element? _findList(Element e) {
    final items = e.children.where((node) => node.localName == 'ol');
    final parent = items.isNotEmpty ? items.first : e;
    return parent.querySelector(_listSelector);
  }

  /// could not apply `> a, p > a` selector
  static Iterable<Element> _finalAnchors(Element parent) {
    final anchors = <Element>[];
    for (final e in parent.children) {
      if (e.localName == 'a') {
        anchors.add(e);
      } else if (e.localName == 'p') {
        anchors.addAll(e.children.where((c) => c.localName == 'a'));
      }
    }
    return anchors;
  }

  static Iterable<Article> _parseList(Element ul) {
    return ul.children.where((e) => e.localName == 'li').map((li) {
      final p = li.querySelector('p');
      var title = (p?.text ?? li.firstChild?.text)?.trim();
      String? ref;
      final links = _finalAnchors(li);
      if (links.isNotEmpty) {
        final a = links.first;
        title = a.text;
        final href = a.attributes['href'];
        ref = href?.replaceAll('\\', '/').replaceAll('^\\/+', '');
      }
      if (title == null) return null;
      final sub = _findList(li);
      final articles = sub == null ? null : _parseList(sub);
      return Article(title: title, ref: ref, articles: articles);
    }).whereType<Article>();
  }
}

/// A record type for a chapter object.
typedef Part = ({String title, Iterable<Article>? articles});

/// A helper class for extracting readme and glossary from raw html.
class Extractor {
  static ({String title, String? desc}) readme(String html) {
    final doc = parse(html);
    final headings = doc.getElementsByTagName('h1');
    final h1 = headings.isNotEmpty ? headings.first : null;
    final p = doc.querySelector('div.paragraph,p');
    return (title: h1?.text.trim() ?? '', desc: p?.text.trim());
  }

  /// Extract a glossary list from raw html text.
  static Iterable<({String name, String? desc})> glossary(String html) {
    final doc = parse(html);
    return doc.getElementsByTagName('h2').map((h2) {
      final next = h2.nextElementSibling;
      final p = next?.localName == 'p'
          ? next
          : next?.getElementsByTagName('p').firstOrNull;
      return (name: h2.text.trim(), desc: p?.innerHtml);
    });
  }

  /// Extract a part list from raw html text as a summary.
  static Iterable<Part> summary(String html) {
    final root = Element.html('<div>$html</div>');
    final parts = _splitParts(root) ?? Iterable.empty();
    return parts;
  }

  /// Extract a article list from raw html text as a lang index.
  static Iterable<Article> langs(String html) {
    final parts = summary(html);
    return parts.isEmpty
        ? Iterable.empty()
        : (parts.first.articles ?? Iterable.empty());
  }

  static Part _makePart(String? title, Element? ul) {
    final articles = ul == null ? null : Article._parseList(ul);
    return (title: title ?? '', articles: articles);
  }

  static bool _isPartNode(Element e) {
    final name = e.localName;
    return name != null && _partSelector.contains(name);
  }

  static Iterable<Part>? _splitParts(Element node) {
    final selector = '$_listSelector, $_partSelector';
    final children = node.children.where((e) {
      final name = e.localName;
      return name != null && selector.contains(name);
    }).toList(growable: false);

    final parts = <Part>[];
    String? title;

    for (final e in children) {
      if (_isPartNode(e)) {
        if (title != null) {
          parts.add(_makePart(title, null));
        }
        title = e.text.trim();
      } else {
        parts.add(_makePart(title, e));
        title = null;
      }
    }
    if (title != null) {
      parts.add(_makePart(title, null));
    }

    return parts;
  }
}
