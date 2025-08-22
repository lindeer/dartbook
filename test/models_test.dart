import 'package:dartbook/cli/logger.dart';
import 'package:dartbook/cli/parser.dart';
import 'package:dartbook/html/html.dart' show Article;
import 'package:dartbook/models/article.dart';
import 'package:dartbook/models/config.dart';
import 'package:dartbook/models/const/config_default.dart';
import 'package:dartbook/models/glossary.dart';
import 'package:dartbook/models/ignore.dart';
import 'package:dartbook/models/part.dart';
import 'package:dartbook/models/summary.dart';
import 'package:test/test.dart';

void main() {
  test('glossary item id', () {
    expect(GlossaryItem('Hello World').id, 'hello-world');
    expect(GlossaryItem('Heinrich (VII)').id, 'heinrich-(vii)');
  });

  test('glossary creation', () {
    final glossary = BookGlossary.fromItems('', [
      (name: 'Hello World', desc: 'Awesome!'),
      (name: 'JavaScript', desc: 'This is a cool language!'),
    ]);
    expect(glossary.items.length, 2);
    expect(glossary['hello-world']?.desc, 'Awesome!');
    expect(glossary['JavaScript']?.desc, null);
    expect(glossary['javascript']?.desc, 'This is a cool language!');
  });

  test('summary article child level', () {
    final empty = SummaryArticle.create(Article(title: ''), '1.1');
    expect(empty.childLevel, '1.1.1');
    final article = SummaryArticle.create(
      Article(
        title: '',
        articles: [
          Article(title: 'Test'),
        ],
      ),
      '1.1',
    );
    expect(article.childLevel, '1.1.2');
  });

  test('summary article isFile', () {
    final a1 = SummaryArticle.create(
      Article(title: '', ref: 'hello.md'),
      '1.1',
    );
    expect(a1.path == 'hello.md', true);

    final a2 = SummaryArticle.create(
      Article(title: '', ref: '/hello.md'),
      '1.1',
    );
    expect(a2.path == 'hello.md', true);

    final a3 = SummaryArticle.create(
      Article(title: '', ref: '/hello.md#world'),
      '1.1',
    );
    expect(a3.path == 'hello.md', true);
  });

  test('summary part level', () {
    final p1 = SummaryPart.create((title: '', articles: null), '1');
    expect(p1.childLevel, '1.1', reason: 'must create the right level');
    final p2 = SummaryPart.create((
      title: '',
      articles: [
        Article(title: 'Test'),
      ],
    ), '1');
    expect(
      p2.childLevel,
      '1.2',
      reason: 'must create the right level when has articles',
    );
  });

  test('summary test', () {
    final firstArticles = [
      Article(title: 'My First Article', ref: 'README.md'),
      Article(title: 'My Second Article', ref: 'article.md'),
      Article(title: 'Article without ref'),
      Article(title: 'Article with absolute ref', ref: 'https://google.fr'),
    ];
    final summary = BookSummary.create(
      '',
      [
        (title: '', articles: firstArticles),
        (title: 'Test', articles: null),
      ],
    );

    expect(summary.parts.length, 2);
    expect(summary[0].articles?.length ?? 0, 4, reason: 'can return a Part');
    final p2 = summary[1];
    expect(p2.title, 'Test');
    expect(p2.articles?.length ?? 0, 0, reason: 'can return a Part[1]');

    final a = summary.byLevel('1.1');
    expect(a?.title, 'My First Article');

    final a2 = summary.byPath('README.md');
    expect(a2?.title, 'My First Article');

    final a3 = summary.byPath('article.md');
    expect(a3?.title, 'My Second Article');

    final a4 = summary.byPath('NOT_EXISTING.md');
    expect(a4?.title, null);

    final another = BookSummary.create(
      '',
      [
        (title: '', articles: firstArticles),
      ],
    );
    final b = another.byLevel('1');
    expect(b?.title, 'My First Article');

  });

  test('summary navigate', () {
    final partI = [
      Article(
        title: 'My First Article',
        ref: 'README.md',
      ),
      Article(
        title: 'My Second Article',
        ref: 'article.md',
      ),
      Article(title: 'Article without ref'),
      Article(
        title: 'Article with absolute ref',
        ref: 'https://google.fr',
      ),
    ];
    final partII = [
      Article(
        title: 'Part II Article',
        ref: 'README.md',
      ),
    ];
    final summary = BookSummary.create(
      '',
      [
        (title: 'Part I', articles: partI),
        (title: 'Part II', articles: partII),
      ],
    );

    final article = summary.byLevel('1.4');
    expect(article?.title, 'Article with absolute ref');
    final next = summary.nextArticle(article!);
    expect(next?.title, 'Part II Article');
    expect(next?.level, '2.1');
    final prev = summary.prevArticle(next!);
    expect(prev?.title, article.title);

    final prevOne = summary.prevArticle(article);
    expect(prevOne?.title, 'My Second Article');
    final nextOne = summary.nextArticle(prevOne!);
    expect(nextOne?.title, article.title);
    final noRef = summary.byLevel('1.3');
    expect(noRef?.title, 'Article without ref');
    final prevNoRef = summary.prevArticle(noRef!);
    expect(prevNoRef?.title, prevOne.title);
  });

  const md = """
# Summary

* [Chapter 1](chapter-1/README.md)
*    
* [首页](chapter-2/首页.md)
    """;

  test('summary parsing', () {
    final parser = MarkdownParser(Logger(false));
    final summary = BookSummary.create('test.md', parser.summary(md));
    final first = summary.parts.first.articles?.first;
    final last = summary.parts.first.articles?.last;

    expect(first?.ref, 'chapter-1/README.md');
    expect(first?.path, 'chapter-1/README.md');
    expect(last?.ref, 'chapter-2/%E9%A6%96%E9%A1%B5.md');
    expect(last?.path, 'chapter-2/首页.md');
  });

  test('config change', () {
    final config = BookConfig('', {
      "hello": {
        "world": 1,
        "test": 'Hello',
        "isFalse": false,
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

  test('config default', () {
    final def = BookConfig.schemaDefault();
    expect(def.keys, configDefault.keys);
    // MapEquality not work as expected!
    expect(_mapEqual(def, configDefault), true);
  });

  test('ignore file and directory', () {
    final ignore = BookIgnore();
    ignore.addAll([
      'a.png',
      '*.jpg',
      'test/b.txt',
      '.git',
      'build**',
      '_book/',
    ]);
    expect(ignore.isIgnored('a.png'), true);
    expect(ignore.isIgnored('b.png'), false);
    expect(ignore.isIgnored('c.jpg'), true);
    expect(ignore.isIgnored('test/a.txt'), false);
    expect(ignore.isIgnored('test/b.txt'), true);
    expect(ignore.isIgnored('.git/'), true);
    expect(ignore.isIgnored('.git/HEAD'), false);
    expect(ignore.isIgnored('build'), true);
    expect(ignore.isIgnored('build/R.java'), true);
    expect(ignore.isIgnored('_book'), true);
    expect(ignore.isIgnored('_book/index.html'), true);
  });
}

bool _mapEqual(Map m1, Map m2) {
  final keys = m1.keys;
  if (keys.length != m2.keys.length) {
    return false;
  }
  for (final k in keys) {
    final v = m1[k];
    final b = v is Map ? _mapEqual(v, m2[k] as Map) : v == m2[k];
    if (!b) {
      return false;
    }
  }
  return true;
}
