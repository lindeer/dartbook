import 'const/configDefault.dart';

class BookConfig {
  final String filename;
  final Map<String, dynamic> values;

  BookConfig.withDefault(this.filename): values = Map.of(schemaDefault());

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

  static Map<String, dynamic> schemaDefault({Map<String, dynamic>? defaults}) {
    final schema = configSchema;
    final def = schema['definitions'] as Map<String, dynamic>?;
    if (defaults != null) {
      def?.addAll(defaults);
    }
    return _makeDefault(schema, def) ?? {};
  }

  /// returns a object that built with default values from json schema
  static dynamic _makeDefault(
      Map<String, dynamic> schema,
      Map<String, dynamic>? defVal) {
    final type = schema['type'];
    if (type == 'object') {
      final properties = schema['properties'] as Map<String, dynamic>?;
      final result = <String, dynamic>{};
      for (final k in (properties?.keys ?? <String>[])) {
        final value = properties?[k] as Map<String, dynamic>?;
        final v = value != null ? _makeDefault(value, defVal) : null;
        if (v != null) {
          result[k] = v;
        }
      }
      return result;
    } else if (schema.containsKey('default')) {
      return schema['default'];
    } else if (defVal != null && defVal.containsKey('default')) {
      return defVal['default'];
    }
  }
}
