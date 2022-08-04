A dart implementation of gitbook-cli for guys who love gitbook.

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

### Extension

Using dartbook, it is easy to custom your book website, just create 'theme' in book project's root directory, in 'theme', create '_layouts' for your book's pages' layout, '_i18n' for different i18n string resources and '_assets' for appearance. It keep same with gitbook's style.

### Patch diff

Git diff is based on line, that means whole line would be labeled even if one character is changed, it is extremely inconvenient to find what we haved revised when doing authoring work. Thanks to [google-diff-match-patch](https://github.com/google/diff-match-patch), we could clearly take on the text change.

Just change command `git diff [<options>]` to `dartbook diff [<options>]`, it would output precisely the revised character.

### TODO

#### plugins system

It is are very powerful to use plugins to extend applications, but that needs dart's reflection functionality, and config runtime jit mode. Need more digest.
