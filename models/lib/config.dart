import 'const/configDefault.dart';

class BookConfig {
  final String filename;
  final Map<String, dynamic> values;

  BookConfig.withDefault(this.filename): values = Map.of(configDefault);

  const BookConfig(this.filename, this.values);

  dynamic operator [](String key) {
    Map<String, dynamic>? obj = values;
    var k = key;
    if (key.contains('.')) {
      final result = _deepObj(key);
      k = result['key'];
      obj = result['obj'];
    }
    final ret = obj?[k];
    return ret is Map ? Map.unmodifiable(ret) : ret;
  }

  T opt<T>(String key, T defVal) => this[key] ?? defVal;

  void operator []=(String key, dynamic value) {
    Map<String, dynamic>? obj = values;
    var k = key;
    if (key.contains('.')) {
      final result = _deepObj(key);
      k = result['key'];
      obj = result['obj'];
    }
    obj?[k] = value;
  }

  Map<String, dynamic> _deepObj(String key) {
    Map<String, dynamic>? obj = values;
    final keys = key.split('.');
    final prefix = keys.sublist(0, keys.length - 1);
    final k = keys.last;
    for (final ik in prefix) {
      obj = obj?[ik] as Map<String, dynamic>?;
    }
    return {
      "key": k,
      "obj": obj,
    };
  }

  void merge(Map<String, dynamic> v) => values.addAll(v);
}
