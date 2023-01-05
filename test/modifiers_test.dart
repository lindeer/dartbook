import 'package:dartbook/cli/modifiers.dart' show GlossaryModifier;
import 'package:dartbook/models/glossary.dart';
import 'package:html/parser.dart' show parse;
import 'package:test/test.dart';

void main() {
  final entries = [
    GlossaryItem('Henry (VII)', desc: '<p>Henry (VII) (1211 – 12? February 1242), a member of the '
        '<a href="https://en.wikipedia.org/wiki/Hohenstaufen">Hohenstaufen</a> dynasty</p>'),
    GlossaryItem('Conrad IV', desc: '<p>Conrad IV of Germany(25 April 1228 – 21 May 1254)</p>'),
  ];

  test('annotate pure text', () {
    const text = "Conrad IV is a brother of Henry (VII)";
    final doc = parse(text);
    GlossaryModifier(entries).annotate(doc);
    final links = doc.querySelectorAll('.glossary-item');
    expect(links.length, 2);

    final conrad = links.first;
    expect(conrad.firstChild?.text, 'Conrad IV');

    final henry = links.last;
    expect(henry.firstChild?.text, 'Henry (VII)');
  });

  test('annotate none word character', () {
    final items = [
      GlossaryItem('Brancaleone von Andalò',),
      GlossaryItem('康拉德四世',),
    ];
    const text = "康拉德四世(Conrad IV)和Brancaleone von Andalò";
    final doc = parse(text);
    GlossaryModifier(items).annotate(doc);
    final links = doc.querySelectorAll('.glossary-item');
    expect(links.length, 2);


    final first = links.first.firstChild!;
    expect(first.text, '康拉德四世');

    final last = links.last.firstChild!;
    expect(last.text, 'Brancaleone von Andalò');
  });

  test('annotate ignore tag', () {
    final doc = parse('<script>Conrad IV is a brother of Henry (VII)</script>');
    GlossaryModifier(entries).annotate(doc);
    expect(doc.querySelectorAll('.glossary-item').length, 0);
  });

  test('annotate ignore class', () {
    final doc = parse('<p class="no-glossary">Conrad IV is a brother of Henry (VII)</p>');
    GlossaryModifier(entries).annotate(doc);
    expect(doc.querySelectorAll('.glossary-item').length, 0);
  });

  test('annotate ignore class', () {
    final doc = parse('People said <code>Conrad IV</code> is a brother of Henry (VII)');
    GlossaryModifier(entries).annotate(doc);
    expect(doc.querySelectorAll('#glossary-item-conrad-iv').length, 0);
  });

  test('annotate ignore class II', () {
    final doc = parse('People said <span class="glossary-item">Conrad IV</span> is a brother of Henry (VII)');
    GlossaryModifier(entries).annotate(doc);
    expect(doc.querySelectorAll('.glossary-item').length, 2);
  });

  test('annotate ignore class III', () {
    final items = [
      entries.first,
      GlossaryItem('IV',),
    ];
    final doc = parse('People said <span class="glossary-item">Conrad IV</span> was Henry IV');
    GlossaryModifier(items).annotate(doc);
    expect(doc.querySelectorAll('.glossary-item').length, 2);
  });
}
