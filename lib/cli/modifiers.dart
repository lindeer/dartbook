import 'package:dartbook/models/glossary.dart';
import 'package:dartbook/models/utils.dart' show slug;
import 'package:html/dom.dart' as dom;

const _ignoredClass = {
  'no-glossary',
  'glossary-item',
};
const _ignoredTag = [
  'code',
  'pre',
  'a',
  'script',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
];

bool _classIgnored(String className) => className.contains(' ')
    ? _ignoredClass.intersection(className.split(' ').toSet()).isNotEmpty
    : _ignoredClass.contains(className);

bool _isIgnored(dom.Element node) {
  final name = node.localName;
  return (name != null && _ignoredTag.contains(name)) ||
      _classIgnored(node.className);
}

final _quoteRegExp = RegExp(r'([\\.+*?\[^\]$(){}=!<>|:])');
final _wordCharacter = RegExp(r'\w');

RegExp _makeRegExp(String entry) {
  final quoted = entry.replaceAllMapped(_quoteRegExp, (m) => '\\${m.group(0)}');
  String reg = '($quoted)';
  if (_wordCharacter.hasMatch(quoted[0])) {
    reg = r'\b' + reg;
  }
  if (_wordCharacter.hasMatch(quoted[quoted.length - 1])) {
    reg = reg + r'\b';
  }
  return RegExp(reg);
}

class GlossaryModifier {
  final Iterable<GlossaryItem> entries;
  final _regexCache = <String, RegExp>{};

  GlossaryModifier(this.entries);

  /// for each entry, modify the whole dom tree, and then next entry
  void annotate(dom.Document doc) {
    final matchedEntries = <String, GlossaryItem>{};
    for (final entry in entries) {
      final name = entry.name;
      final regex = (_regexCache[name] ??= _makeRegExp(name));
      List<dom.Node>? replacing;
      doc.visit((node) {
        if (node is dom.Element && _isIgnored(node)) {
          return false;
        }
        if (node.nodeType != dom.Node.TEXT_NODE) {
          return true;
        }
        final data = (node as dom.Text).data;
        if (data.trim().isEmpty) {
          return true;
        }

        final e = _replaceNode(node, regex, (m) {
          matchedEntries[entry.name] = entry;
          return '<span class="glossary-item" data-target="glossary-${entry.id}">$name</span>';
        });
        if (e != null) {
          final parent = node.parent;
          parent?.insertBefore(e, node);
          final list = (replacing ??= <dom.Node>[]);
          list.add(node);
        }
        return true;
      });

      /// remove replacing nodes after traversal
      replacing?.forEach((e) {
        e.remove();
      });
    }
    final container = doc.getElementById('body-container');
    if (container != null) {
      for (final entry in matchedEntries.values) {
        final (id, desc) = (entry.id, entry.desc);
        final rawHtml = desc == null
            ? null
            : '<div id="glossary-$id" class="glossary-detail">$desc</div>';
        if (rawHtml != null) {
          container.append(dom.Element.html(rawHtml));
        }
      }
    }
  }
}

dom.Node? _replaceNode(
  dom.Node node,
  RegExp regex,
  String Function(Match match) matcher,
) {
  final old = (node as dom.Text).data;
  final html = old.replaceAllMapped(regex, matcher);
  if (old == html) {
    return null;
  } else if (html.contains('<')) {
    return dom.DocumentFragment.html(html);
  } else {
    node.text = html;
    return null;
  }
}

extension _NodeExt on dom.Node {
  void visit(bool Function(dom.Node e) visitor) {
    final accept = visitor.call(this);
    if (!accept) {
      return;
    }
    final children = nodes.toList(growable: false);
    for (final child in children) {
      child.visit(visitor);
    }
  }
}

void addHeadingId(dom.Node doc) {
  final nodes = doc is dom.Element ? [doc] : doc.children;
  for (final e in nodes) {
    final elements = e.querySelectorAll('h1,h2,h3,h4,h5,h6');
    elements.forEach(_addId);
  }
}

void _addId(dom.Element e) {
  if (e.id == '') {
    e.id = slug(e.text);
  }
}
