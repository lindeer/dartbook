
Dartbook is a dart implementation of gitbook-cli for guys who loves gitbook!

# Installation

```
$ dart pub global activate dartbook
$ export PATH=$PATH:~/.pub-cache/bin
```

# Create a book

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
