import 'package:glob/glob.dart' show Glob;

class BookIgnore {
  final _rules = <Glob>[];

  Iterable<String> get rules => _rules.map((e) => e.pattern);

  bool isIgnored(String filename) {
    for (final r in _rules) {
      if (r.matches(filename)) {
        return true;
      }
    }
    return false;
  }

  Iterable<String> _refineRule(Iterable<String> rules) sync* {
    for (final r in rules) {
      if (r.endsWith('/')) {
        yield r.substring(0, r.length - 1);
        yield '$r*';
      } else {
        yield r;
      }
    }
  }

  void add(String rule) {
    addAll([rule]);
  }

  void addAll(Iterable<String> rules) {
    _rules.addAll(_refineRule(rules).map((e) => Glob(e)));
  }

  void update(BookIgnore ignore) {
    _rules.addAll(ignore._rules);
  }
}
