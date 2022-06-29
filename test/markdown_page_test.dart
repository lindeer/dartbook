import 'package:dartbook/markdown/md_parser.dart';
import 'package:test/test.dart';

void main() {
  test('basic page parsing', () {
    final parser = MdParser();
    expect(parser.page('# Hello').content, '<h1>Hello</h1>\n');
    // expect(parser.page('# Hello {#test}').content, '<h1 id="test">Hello </h1>\n');
    expect(parser.page('[Cool stuff](https://it.wikipedia.org/wiki/Savelli_(famiglia))').content,
        '<p><a href="https://it.wikipedia.org/wiki/Savelli_(famiglia)">Cool stuff</a></p>\n',
        reason: 'link should contain parentheses');
    expect(parser.page('good<span>nice</span>').content, '<p>good<span>nice</span></p>\n',
        reason: 'content contains inline html');
    expect(parser.page('good\n<p>nice</p>').content, '<p>good</p><p>nice</p>\n',
        reason: 'content contains paragraph html');
    expect(parser.page('good\n<span>nice</span>').content, '<p>good\n<span>nice</span></p>\n',
        reason: 'content contains html');
    expect(parser.page("Hello `world`").content, '<p>Hello <code>world</code></p>\n',
        reason: 'content contains inline code');
    expect(parser.page("""
Hello
```
world
```
    """).content,
        '<p>Hello</p>\n<pre><code>world\n</code></pre>\n',
        reason: 'content contains block code');
  });
}
