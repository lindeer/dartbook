
class BookIgnore {
  final _rules = <String>[];

  Iterable<String> get rules => _rules;

  bool isIgnored(String filename) {
    for (final r in _rules) {
      if (r.contains(filename)) {
        return true;
      }
    }
    return false;
  }

  void add(String rule) {
    _rules.add(rule);
  }

  void addAll(Iterable<String> rules) {
    _rules.addAll(rules);
  }

  void update(BookIgnore ignore) {
    _rules.addAll(ignore._rules);
  }
}
