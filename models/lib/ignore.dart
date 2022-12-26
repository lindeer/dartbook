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

  void add(String rule) {
    _rules.add(Glob(rule));
  }

  void addAll(Iterable<String> rules) {
    _rules.addAll(rules.map((e) => Glob(e)));
  }

  void update(BookIgnore ignore) {
    _rules.addAll(ignore._rules);
  }
}
