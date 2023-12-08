Dartbook is a dart implementation of gitbook-cli for guys who loves gitbook.

![Multilingual Entry](https://raw.githubusercontent.com/lindeer/dartbook/main/doc/demo_entry.jpg)


![Book page looking](https://raw.githubusercontent.com/lindeer/dartbook/main/doc/dartbook-looking.gif)

### Installation

* Requirement: [Dart](https://dart.dev/get-dart) sdk >= 3.0

`dartbook` should be "activated".

```
$ dart pub global activate dartbook
$ export PATH=$PATH:~/.pub-cache/bin
```

### Create a book

set up a boilerplate book:
```sh
$ dartbook init
```

Preview and serve your book using:
```sh
$ dartbook serve
```

Build the static website using:
```sh
$ dartbook build
```

Show what have changed in one document:
```sh
$ dartbook diff [file1] [file2] ...
```

Nearly same with gitbook!

### Feature

* Write using Markdown
* Patch diff of characters
* Output as a website or ebook (pdf, epub, mobi)
* Multi-Languages
* Lexicon / Glossary
* Variables and Templating
* Content References
* Material default theme

### Why

Dartbook aims to smooth the migration from GitBook (Legacy) to Dart.

[gitbook-cli](https://github.com/GitbookIO/gitbook) stopped developping since 5 years ago, it was used widely but with many shortage.

First, it is very slow, especially for those books containing over 100 pages, in my case, it cost over 5 minutes for my project, which contains 3 language books, 168 pages for each.

Second, it contains some issues, e.g. glossary matching in different lingual text.

There is a nodejs project forked of gitbook called [honkit](https://github.com/honkit/honkit), but it inherits bugs and errors since gitbook, and its update and bug-fixing is not so active.

### What

Try to keep everything same with gitbook, dartbook is compatible to run existing book projects. A little differences are:

1. No glossary generated page. All glossary entries are shown as tooltip, no more link jumping.

2. Encoding text as slug id. In different lingual text, many glossories contain special characters.

3. No mulilingual book any more in code, every book is managed by `BookContext`. `langPath` of `Book` is `''` if book is located in project root.

4. Book navigation would ignore invalid link article.

5. No more font-sizing, theme-changing settings config, but they would come back in the future if new UX design appears.

### Theme development

If you would like to develop your own dartbook theme, go to [dartbook-theme](https://github.com/lindeer/dartbook-theme).

### Patch diff

Git diff is based on line, that means whole line would be labeled even if one character is changed, it is extremely inconvenient to find what we haved revised when doing authoring work. Thanks to [google-diff-match-patch](https://github.com/google/diff-match-patch), we could clearly take on the text change.

Just change command `git diff [<options>]` to `dartbook diff [<options>]`, it would output precisely the revised character.

![](doc/diff-demo.png)


### plugins system

It is very powerful to use plugins to extend applications, but currently we had no plan for it.
