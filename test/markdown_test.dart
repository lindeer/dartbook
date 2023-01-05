import 'package:dartbook/logger.dart';
import 'package:dartbook/parser.dart';
import 'package:test/test.dart';

void main() {
  test('Languages parsing', () {
    const md = """
# Languages

* [English](en/)
* [French](fr/)
    """;
    final lang = MarkdownParser(Logger(false)).langs(md);
    expect(lang.articles.length, 2);

    final first = lang.articles.first;
    final last = lang.articles.last;
    expect(first.ref, 'en/');
    expect(first.title, 'English');

    expect(last.ref, 'fr/');
    expect(last.title, 'French');
  });


  test('Readme parsing', () {
    const md = """
# This is the title

This is the book description.

other content
...

    """;
    final readme = MarkdownParser(Logger(false)).readme(md);
    expect(readme.title, 'This is the title',
        reason: 'should extract the right title');
    expect(readme.desc, 'This is the book description.',
        reason: 'should extract the right description');
  });

  test('Glossary parsing', () {
    const md = """
## Magic
Sufficiently advanced technology, beyond the understanding of the observer producing a sense of wonder.

Hello, I am random noise in the middle of this beautiful Glossary. (Really astonishing !)

## Clojure
Lisp re-invented for hipsters.

## Go
Go Go Google [Wow](https://www.google.com)

Fantastic, I love code too ! :

```py

def f(x):
    return x * 4

# Wow this is some really awesome code
# totally mind blowing
# but we don't care, it shouldn't be in our glossary !
print(f(9))
```

## Gitbook

Awesome project. Really amazing, I'm really at a loss for words ...
    """;
    final glossaries = MarkdownParser(Logger(false)).glossary(md);
    expect(glossaries.length, 4,
        reason: 'should only get heading + paragraph pairs');
    expect(true, glossaries.any((g) => g.desc != null),
        reason: 'should output simple name/description objects');
  });

  test('Empty summary parsing', () {
    const md = """
# Summary

* [Chapter 1](chapter-1/README.md)
*    

    """;
    final parts = MarkdownParser(Logger(false)).summary(md).parts;
    // expect(parts.length, 1);
    expect(parts.first.articles?.length, 1,
        reason: 'should allow ignore empty entries');
  });

  test('Whitespace summary parsing', () {
    const md = """
# Summary

* [Chapter 1](chapter-1/README.md)
    * [Article 1](chapter-1/ARTICLE1.md)
    * [Article 2](chapter-1/ARTICLE2.md)
        * [article 1.2.1](\\chapter-1\\ARTICLE-1-2-1.md)
        * [article 1.2.2](/chapter-1/ARTICLE-1-2-2.md)

* [Chapter 2](chapter-2/README.md)
* [Chapter 3](chapter-3/README.md)
* [Chapter 4](chapter-4/README.md)

    * Unfinished article

* Unfinished Chapter
    """;
    final parts = MarkdownParser(Logger(false)).summary(md).parts;
    // expect(parts.length, 1);
    expect(parts.first.articles?.length, 5,
        reason: 'should allow lists separated by whitespace');
  });

  test('Summary parts test', () {
    const md = """
# Summary

* [Chapter 1](chapter-1/README.md)

## Part 2

* [Chapter 2](chapter-2/README.md)

## Part 3

* [Chapter 3](chapter-3/README.md)

    """;

    final parts = MarkdownParser(Logger(false)).summary(md).parts;
    // expect(parts.length, 1);
    expect(parts.length, 3, reason: 'should split parts');
  });

  test('Normal summary test', () {
    const md = """
# Summary

* [Chapter 1](chapter-1/README.md)
    * [Article 1](chapter-1/ARTICLE1.md)
    * [Article 2](chapter-1/ARTICLE2.md)
        * [article 1.2.1](\\chapter-1\\ARTICLE-1-2-1.md)
        * [article 1.2.2](/chapter-1/ARTICLE-1-2-2.md)
* [Chapter 2](chapter-2/README.md)
* [Chapter 3](chapter-3/README.md)
* [Chapter 4](chapter-4/README.md)
    * Unfinished article
* Unfinished Chapter

----

* Chapter 4

    """;
    final parts = MarkdownParser(Logger(false)).summary(md).parts;
    final primary = parts.first;
    expect(primary.articles?.length, 5, reason: 'should detect chapters');
    expect(primary.articles?.take(3).map((e) => e.articles?.length ?? 0),
        [2, 0, 0], reason: 'should support articles');
    expect(primary.articles?.take(5).map((e) => e.ref), [
      'chapter-1/README.md',
      'chapter-2/README.md',
      'chapter-3/README.md',
      'chapter-4/README.md',
      null,
    ], reason: 'should normalize paths from .md');
    expect(primary.articles?.take(5).map((e) => e.title), [
      'Chapter 1',
      'Chapter 2',
      'Chapter 3',
      'Chapter 4',
      'Unfinished Chapter',
    ], reason: 'should extract title from .md');
  });
}
