import 'package:dartbook_models/glossary.dart';
import 'package:test/test.dart';
import 'package:dartbook/modifiers.dart' show GlossaryModifier;
import 'package:html/parser.dart' show parse;
import 'package:dartbook_models/utils.dart' as utils;

void main() {
  final entries = [
    GlossaryItem('Henry (VII)', desc: '<p>Henry (VII) (1211 – 12? February 1242), a member of the '
        '<a href="https://en.wikipedia.org/wiki/Hohenstaufen">Hohenstaufen</a> dynasty</p>'),
    GlossaryItem('Conrad IV', desc: '<p>Conrad IV of Germany(25 April 1228 – 21 May 1254)</p>'),
  ];

  test('annotate pure text', () {
    const text = "Conrad IV is a brother of Henry (VII)";
    final doc = parse(text);
    GlossaryModifier(entries).annotate('GLOSSARY.md', doc);
    final links = doc.querySelectorAll('a');
    expect(links.length, 2);

    final conrad = links.first;
    expect(conrad.attributes['href'], '/GLOSSARY.md#conrad-iv');
    expect(conrad.text, 'Conrad IV');
    expect(conrad.className.contains('glossary-term'), true);

    final henry = links.last;
    expect(henry.attributes['href'], '/GLOSSARY.md#henry-(vii)');
    expect(henry.text, 'Henry (VII)');
    expect(henry.className.contains('glossary-term'), true);
  });

  test('annotate none word character', () {
    final items = [
      GlossaryItem('Brancaleone von Andalò',),
      GlossaryItem('康拉德四世',),
    ];
    const text = "康拉德四世(Conrad IV)和Brancaleone von Andalò";
    final doc = parse(text);
    GlossaryModifier(items).annotate('GLOSSARY.md', doc);
    final links = doc.querySelectorAll('a');
    expect(links.length, 2);


    final first = links.first;
    expect(first.attributes['href'], '/GLOSSARY.md#${utils.slug('康拉德四世')}');
    expect(first.text, '康拉德四世');

    final last = links.last;
    expect(last.attributes['href'], '/GLOSSARY.md#brancaleone-von-andal${utils.slug('ò')}');
    expect(last.text, 'Brancaleone von Andalò');
  });

  test('annotate ignore tag', () {
    final doc = parse('<script>Conrad IV is a brother of Henry (VII)</script>');
    GlossaryModifier(entries).annotate('GLOSSARY.md', doc);
    expect(doc.querySelectorAll('a').length, 0);
  });

  test('annotate ignore class', () {
    final doc = parse('<p class="no-glossary">Conrad IV is a brother of Henry (VII)</p>');
    GlossaryModifier(entries).annotate('GLOSSARY.md', doc);
    expect(doc.querySelectorAll('a').length, 0);
  });

  test('annotate ignore class', () {
    final doc = parse('People said <code>Conrad IV</code> is a brother of Henry (VII)');
    GlossaryModifier(entries).annotate('GLOSSARY.md', doc);
    expect(doc.querySelectorAll('a').length, 1);
  });
}
