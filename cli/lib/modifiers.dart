import 'dart:convert' show HtmlEscape;
import 'package:html/dom.dart';

import 'package:dartbook_models/glossary.dart';

const _ignoredClass = 'no-glossary';
const _ignoredTag = ['code', 'pre', 'a', 'script', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'];

bool _isIgnored(Element node) {
  final name = node.localName;
  return (name != null && _ignoredTag.contains(name)) || (node.className == _ignoredClass);
}

final _quoteRegExp = RegExp(r'([\\\.\+\*\?\[\^\]\$\(\)\{\}\=\!\<\>\|\:])');
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

final _escape = HtmlEscape();

/// for each entry, modify the whole dom tree, and then next entry
void annotateText(Iterable<GlossaryItem> entries, String file, Node doc) {
  for (final entry in entries) {
    List<Node>? replacing;
    doc.visit((node) {
      if (node is Element && _isIgnored(node)) {
        return false;
      }
      if (node.nodeType != Node.TEXT_NODE) {
        return true;
      }

      final id = entry.id;
      final desc = entry.desc;
      final title = desc != null ? _escape.convert(desc) : '';
      final e = _replaceNode(node, entry, (m) {
        return '<a href="/$file#$id" class="glossary-term" title="$title">${m.group(0)}</a>';
      });
      if (e != null) {
        final parent = node.parent;
        parent?.insertBefore(e, node);
        final list = (replacing ??= <Node>[]);
        list.add(node);
      }
      return true;
    });

    /// remove replacing nodes after traversal
    replacing?.forEach((e) {
      e.remove();
    });
  }
}

Node? _replaceNode(Node node, GlossaryItem entry, String Function(Match match) matcher) {
  final regex = _makeRegExp(entry.name);
  final old = (node as Text).data;
  final html = old.replaceAllMapped(regex, matcher);
  if (old == html) {
    return null;
  } else if (html.contains('<')) {
    return DocumentFragment.html(html);
  } else {
    node.text = html;
    return null;
  }
}

extension _NodeExt on Node {
  void visit(bool Function(Node e) visitor) {
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
