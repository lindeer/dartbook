
import 'dart:io' show File;

import 'package:dartbook_html/summary.dart' show Article, Part;
import 'package:dartbook_models/article.dart';
import 'package:dartbook_models/config.dart';
import 'package:dartbook_models/glossary.dart';
import 'package:dartbook_models/part.dart';
import 'package:dartbook_models/summary.dart';
import 'package:test/test.dart';

void main() {
  test('glossary item id', () {
    expect(GlossaryItem('Hello World').id, 'hello-world');
    expect(GlossaryItem('Heinrich (VII)').id, 'heinrich-(vii)');
  });

  test('glossary creation', () {
    final glossary = BookGlossary.fromItems('', [
      GlossaryItem('Hello World', desc: 'Awesome!'),
      GlossaryItem('JavaScript', desc: 'This is a cool language!'),
    ]);
    expect(glossary.items.length, 2);
    expect(glossary['hello-world']?.desc, 'Awesome!');
    expect(glossary['JavaScript']?.desc, null);
    expect(glossary['javascript']?.desc, 'This is a cool language!');
  });

  test('summary article child level', () {
    final empty = SummaryArticle.create(Article(title: ''), '1.1');
    expect(empty.childLevel, '1.1.1');
    final article = SummaryArticle.create(Article(
        title: '',
        articles: [
          Article(title: 'Test'),
        ]), '1.1');
    expect(article.childLevel, '1.1.2');
  });

  test('summary article isFile', () {
    final a1 = SummaryArticle.create(Article(title: '', ref: 'hello.md'), '1.1');
    final file = File('hello.md');
    expect(a1.isFile(file), true);

    final a2 = SummaryArticle.create(Article(title: '', ref: '/hello.md'), '1.1');
    expect(a2.isFile(file), true);

    final a3 = SummaryArticle.create(Article(title: '', ref: '/hello.md#world'), '1.1');
    expect(a3.isFile(file), true);
  });

  test('summary part level', () {
    final p1 = SummaryPart.create(Part(title: ''), '1');
    expect(p1.childLevel, '1.1', reason: 'must create the right level');
    final p2 = SummaryPart.create(Part(title: '', articles: [
      Article(title: 'Test'),
    ]), '1');
    expect(p2.childLevel, '1.2', reason: 'must create the right level when has articles');
  });

  test('summary test', () {
    final summary = BookSummary.create('', [
      Part(
        title: '',
        articles: [
          Article(title: 'My First Article', ref: 'README.md',),
          Article(title: 'My Second Article', ref: 'article.md',),
          Article(title: 'Article without ref'),
          Article(title: 'Article with absolute ref', ref: 'https://google.fr'),
        ]
      ),
      Part(title: 'Test'),
    ]);

    expect(summary.parts.length, 2);
    expect(summary[0].articles?.length ?? 0, 4,
        reason: 'can return a Part');
    final p2 = summary[1];
    expect(p2.title, 'Test');
    expect(p2.articles?.length ?? 0, 0,
        reason: 'can return a Part[1]');

    final a = summary.byLevel('1.1');
    expect(a?.title, 'My First Article');

    final a2 = summary.byPath('README.md');
    expect(a2?.title, 'My First Article');

    final a3 = summary.byPath('article.md');
    expect(a3?.title, 'My Second Article');

    final a4 = summary.byPath('NOT_EXISTING.md');
    expect(a4?.title, null);
  });

  test('config change', () {
    final config = BookConfig('', {
      "hello": {
        "world": 1,
        "test": 'Hello',
        "isFalse": false
      }
    });

    expect(config['hello'] is Map, true);
    expect(config['hello.world'], 1, reason: 'must return deep value');
    expect(config.opt('hello.nonExistant', 'defaultValue'), 'defaultValue');
    expect(config.opt('hello.isFalse', true), false);

    config['hello.world'] = 2;
    final hello = config['hello'];
    final world = config['hello.world'];
    expect(hello is Map, true);
    expect((hello as Map).length, 3);
    expect(world, 2, reason: 'must set deep value');
  });
}
