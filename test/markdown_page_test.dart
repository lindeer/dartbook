import 'package:dartbook/cli/logger.dart';
import 'package:dartbook/cli/parser.dart';
import 'package:test/test.dart';

void main() {
  test('basic page parsing', () {
    final parser = MarkdownParser(Logger(false));
    expect(parser.page('# Hello'), '<h1>Hello</h1>\n');
    // expect(parser.page('# Hello {#test}').content, '<h1 id="test">Hello </h1>\n');
    expect(parser.page('[Cool stuff](https://it.wikipedia.org/wiki/Savelli_(famiglia))'),
        '<p><a href="https://it.wikipedia.org/wiki/Savelli_(famiglia)">Cool stuff</a></p>\n',
        reason: 'link should contain parentheses');
    expect(parser.page('good<span>nice</span>'), '<p>good<span>nice</span></p>\n',
        reason: 'content contains inline html');
    expect(parser.page('good\n<p>nice</p>'), '<p>good</p>\n<p>nice</p>\n',
        reason: 'content contains paragraph html');
    expect(parser.page('good\n<span>nice</span>'), '<p>good\n<span>nice</span></p>\n',
        reason: 'content contains html');
    expect(parser.page("Hello `world`"), '<p>Hello <code>world</code></p>\n',
        reason: 'content contains inline code');
    expect(parser.page("""
Hello
```
world
```
    """),
        '<p>Hello</p>\n<pre><code>world\n</code></pre>\n',
        reason: 'content contains block code');
  });
}
