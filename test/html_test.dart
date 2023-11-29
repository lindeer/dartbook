library dartbook.html;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook/html/html.dart';
import 'package:dartbook/html/langs.dart';
import 'package:dartbook/html/summary.dart';
import 'package:test/test.dart';

void main() {
  test('readme', () {
    const text = """
<h1>Preface</h1>

<p>This is the book description.</p>

<p>other content
...</p>
""";
    final result = Extractor.readme(text);
    expect(result.title, 'Preface');
    expect(result.desc, 'This is the book description.');
  });

  test('glossary', () {
    const html = """
<h1>Glossary</h1>

<h2>Magic</h2>

<p>Sufficiently advanced technology, beyond the understanding of the observer producing a sense of wonder.</p>

<p>Hello, I am random noise in the middle of this beautiful Glossary. (Really astonishing !)</p>

<h2>PHP</h2>

<p>An atrocious language, invented for the sole purpose of inflicting pain and suffering amongst the proframming wizards of this world.</p>

<h2>Clojure</h2>

<p>Lisp re-invented for hipsters.</p>

<h2>Go</h2>

<p>Go Go Google <a href="https://www.google.com">Wow</a></p>

<p>Fantastic, I love code too ! :</p>

<p>```</p>

<p>def f(x):
    return x * 4</p>

<h1>Wow this is some really awesome code</h1>

<h1>totally mind blowing</h1>

<h1>but we don't care, it shouldn't be in our glossary !</h1>

<p>print(f(9))
```</p>

<h2>Gitbook</h2>

<p>Awesome project. Really amazing, I'm really at a loss for words ...</p>
""";
    final entries = Extractor.glossary(html);
    expect(entries.length, 5);
    assert(entries.any((e) => e.name.isNotEmpty && e.desc != null));

    final first = entries.first;
    expect(first.name, 'Magic');
    expect(first.desc, 'Sufficiently advanced technology, beyond the understanding of the observer producing a sense of wonder.');
  });

  test('empty desc', () {
    const html = """
<h1>Terms</h1>
<h1>Names</h1>
<h1>Addresses</h1>
""";
    final entries = Extractor.glossary(html);
    expect(entries.length, 0);
  });

  test('empty glossary', () {
    const html = """
<h2>Terms</h2>
<p>Some specific noums</p>
<h2>Edinburg</h2>
""";
    final entries = Extractor.glossary(html);
    expect(entries.length, 2);
    final e = entries.firstWhereOrNull((e) => e.name == 'Edinburg');
    assert(e != null && e.desc == null);
  });

  test('empty summary', () {
    const html = """
<h1>Summary</h1>

<h2>First empty part</h2>

<h2>Part 1</h2>

<ul>
    <li><a href="chapter-1/README.md">Chapter 1</a></li>
    <li><a href="chapter-2/README.md">Chapter 2</a></li>
    <li><a href="chapter-3/README.md">Chapter 3</a></li>
</ul>

<!-- Untitled part here -->

<ul>
    <li><a href="chapter-1/README.md">Chapter for untitled part</a></li>
</ul>

<h2>Empty part</h2>

<h2>Part 2</h2>

<ul>
    <li><a href="chapter-1/README.md">Chapter for Part 2</a></li>
</ul>

<h2>Penultimate empty part</h2>

<h2>Last empty part</h2>
    """;
    final summary = Summary.from(html);
    expect(summary.parts.length, 7);
    expect(summary.parts.map((e) => e.title), [
      'First empty part',
      'Part 1',
      '',
      'Empty part',
      'Part 2',
      'Penultimate empty part',
      'Last empty part'
    ], reason: 'should detect empty parts');
  });

  test('normal summary', () {
    const html = """
<h1>Summary</h1>

<ul>
    <li>
        <a href="chapter-1/README.md">Chapter 1</a>
        <ul>
            <li><a href="chapter-1/ARTICLE1.md">Article 1</a></li>
            <li
                ><a href="chapter-1/ARTICLE2.md">Article 2</a>
                <ul>
                    <li><a href="\\chapter-1\\ARTICLE-1-2-1.md">article 1.2.1</a></li>
                    <li><a href="/chapter-1/ARTICLE-1-2-2.md">article 1.2.2</a></li>
                </ul>
            </li>
        </ul>
    </li>
    <li><a href="chapter-2/README.md">Chapter 2</a></li>
    <li><a href="chapter-3/README.md">Chapter 3</a></li>
    <li>
        <a href="chapter-4/README.md">Chapter 4</a>
        <ul>
            <li>Unfinished article</li>
        </ul>
    </li>
    <li>Unfinished Chapter</li>
</ul>

<h2>Part 2</h2>

<ul>
    <li>
        <a href="chapter-1/README.md">Chapter 1</a>
    </li>
</ul>

<ul>
    <li>
        <a href="chapter-1/README.md">Chapter 1</a>
    </li>
</ul>
    """;
    final summary = Summary.from(html);
    final parts = summary.parts;
    expect(parts.length, 3, reason: 'should detect parts');
    expect(parts.take(3).map((e) => e.title), ['', 'Part 2', ''],
        reason: 'should detect title');

    final primary = parts.first;
    expect(primary.articles?.length, 5, reason: 'should detect chapters');

    final second = parts.toList(growable: false)[1];
    expect(second.articles?.length, 1, reason: 'should detect chapters in other parts');
    expect(primary.articles?.take(3).map((e) => e.articles?.length ?? 0), [2,0,0],
        reason: 'should support articles');

    final first5 = primary.articles?.take(5);
    expect(first5?.map((e) => e.ref).last, null, reason: 'should detect paths');
    expect(first5?.map((e) => e.title).contains(null), false, reason: 'should detect titles');

    expect(primary.articles?.take(3).map((e) => e.ref), [
      'chapter-1/README.md',
      'chapter-2/README.md',
      'chapter-3/README.md',
    ], reason: 'should normalize paths from .md');
  });

  test('Languages parsing', () {
    const html = """
<h1>Languages</h1>

<ul>
<li><a href="en/">English</a></li>
<li><a href="fr/">French</a></li>
</ul>
    """;
    final langs = Langs.from(html);
    final first = langs.articles.first;
    final last = langs.articles.last;
    expect(first.ref, 'en/');
    expect(first.title, 'English');

    expect(last.ref, 'fr/');
    expect(last.title, 'French');
  });
}
