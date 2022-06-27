import 'package:dartbook/html/glossary.dart';
import 'package:dartbook/html/readme.dart';
import 'package:test/test.dart';

void main() {
  test('readme', () {
    const text = """
<h1>Preface</h1>

<p>This is the book description.</p>

<p>other content
...</p>
""";
    final result = readme(text);
    expect(result['title'], 'Preface');
    expect(result['description'], 'This is the book description.');
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
    final entries = glossary(html);
    expect(entries.length, 5);
    assert(entries.any((e) => e['name'] != null && e['description'] != null));
  });
}
