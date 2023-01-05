Dartbook is a dart implementation of gitbook-cli for guys who loves gitbook.

Thanks to git, we could directly use this distributed storage.

### Why

[gitbook-cli](https://github.com/GitbookIO/gitbook) stopped developping since 5 years ago, it was used widely but with many shortage.

First, it is very slow, especially for those books containing over 100 pages, in my case, it cost over 5 minutes for my project, which contains 3 language books, 168 pages for each.

Second, it contains some issues, e.g. glossary matching in different lingual text.

### What

Try to keep everything same with gitbook, so it is compatible to run existing book projects. A little differences are:

1. No glossary generated page. All glossary entries are shown current page, no more jumping to glossary page.

2. Encoding text as slug id. In different lingual text, many glossories contain special characters.

3. No mulilingual book any more in code, every book is managed by `BookContext`. `langPath` of `Book` is `''` if book is located in project root.

4. Book navigation would ignore invalid link article.

### Extension

Using dartbook, it is easy to custom your book website, just create 'theme' in book project's root directory, in 'theme', create '_layouts' for your book's pages' layout, '_i18n' for different i18n string resources and '_assets' for appearance. It keep same with gitbook's style.

### Theme development

Dartbook's theme based on [materialize](https://github.com/materializecss/materialize/) css framework. If you would like to custom your own theme style, just did as follow steps:

  1. Download latest materialize source package, e.g. [materialize-src-v1.2.0.zip](https://github.com/materializecss/materialize/releases/download/1.2.0/materialize-src-v1.2.0.zip). Extract it and move its sass directory to `$dartbookRoot/theme/web`. We need materialize's components to build our own styles.
  2. Install dart sass command line tool: `dart pub global activate webdev sass`, of course, make sure your envrionment variables include `~/.pub-cache/bin`: `export PATH=$PATH:~/.pub-cache/bin`.
  3. `cd $dartbookRoot/theme && sass web/styles.scss web/styles.css`, and then run `webdev serve`
  4. Open `http://127.0.0.1:8080` in your browser, and start to modify something.
  5. `main.dart` would finally compile to `dartbook.js`, its main functionality is to show glossary tooltips and bind events for them. `materialize.js` is entirely copied as dartbook's assets. `build.sh` is a helper script for file copy and rename, run it when you finally finished theme developing.
  6. when you started to develop a theme in real world, you may not need chang theme resource files in `cli/theme`, then just create a `theme` directory as `Extension` part above told, your book project would apply newly changed theme resources.

### Patch diff

Git diff is based on line, that means whole line would be labeled even if one character is changed, it is extremely inconvenient to find what we haved revised when doing authoring work. Thanks to [google-diff-match-patch](https://github.com/google/diff-match-patch), we could clearly take on the text change.

Just change command `git diff [<options>]` to `dartbook diff [<options>]`, it would output precisely the revised character.

![](docs/diff-demo.png)

### TODO

Dartbook is still in progress, 'cause some dependent libaries are incomplete.

#### work in progress

1. Template engine. gitbook-3.1.1 using [nunjucks 2.5.2](https://mozilla.github.io/nunjucks) as its template engine, while there is no dart-nunjucks. Fortunately, there is [jinja.dart](pub.flutter-io.cn/packages/jinja) available, a dart implementation of jinja, a template engine which inspired nunjucks. Unforunately, it is still being in progress (2022-08-04), and some key feature not implemtented; e.g. Macros Control Structure, some template layout file in old gitbook have to replace `macro` with `with` statement to implement that goal.

    Some other issues would cause crash, e.g. like `{% if a.b and a.b.c %}` if given data `{"a":{}}`(0.4.0-dev.40).

2. Markdown parser. It is incomprehensible that [markdown: 5.0.0](https://pub.flutter-io.cn/packages/markdown), dart team's official library, [did not and will not implement footnotes](https://github.com/dart-lang/markdown/issues/342), which is so popular in book reading. However, recently there is a marvelous [dart_markdown: 2.0.0](https://pub.flutter-io.cn/packages/dart_markdown), supporting footnotes feature.

3. Ignore rule parser. Currently there is no ignore rule parser available like [ignore 3.1.2](https://github.com/kaelzhang/node-ignore) in gitbook.

Indeed, dart's ecosystem is far behind js.

#### plugins system

It is are very powerful to use plugins to extend applications, but that needs dart's reflection functionality, and config runtime jit mode. Need more digest.
