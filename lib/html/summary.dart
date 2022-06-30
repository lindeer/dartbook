library dartbook.html;

import 'package:html/dom.dart';

const _listSelector = 'ol, ul';
const _linkSelector = '> a, p > a';
const _partSelector = 'h2, h3, h4';

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

  static Iterable<Article> _parseList(Element ul) {
    return ul.children.where((e) => e.localName == 'li').map((li) {
      final p = li.querySelector('p');
      var title = (p?.text ?? li.firstChild?.text)?.trim();
      String? ref;
      final links = li.querySelectorAll(_linkSelector);
      if (links.isNotEmpty) {
        final a = links.first;
        title = a.text;
        ref = a.attributes['href']?.replaceAll('\\', '/')
            .replaceAll('^\\/+', '');
      }
      if (title == null) return null;
      final sub = _findList(li);
      final articles = sub == null ? null : _parseList(sub);
      return Article(title: title, ref: ref, articles: articles);
    }).whereType<Article>();
  }
}

class Part {
  final String title;
  final Iterable<Article>? articles;

  Part({required this.title, this.articles});

  static Part make(String? title, Element? ul) {
    final articles = ul == null ? null : Article._parseList(ul);
    return Part(title: title ?? '', articles: articles);
  }
}

class Summary {
  final Iterable<Part> parts;

  const Summary._(this.parts);

  /// Parse an HTML content into a tree of parts
  static Summary from(String html) {
    final root = Element.html('<div>$html</div>');
    root.querySelector('$_listSelector, $_partSelector');
    final parts = _splitParts(root) ?? [];
    return Summary._(parts);
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
          parts.add(Part.make(title, null));
        }
        title = e.text.trim();
      } else {
        parts.add(Part.make(title, e));
        title = null;
      }
    }
    if (title != null) {
      parts.add(Part.make(title, null));
    }

    return parts;
  }
}
