import 'package:jinja/jinja.dart' as j;

class TemplateLoader extends j.Loader {
  final Map<String, String> parent;
  final j.Loader other;

  TemplateLoader(this.parent, this.other);

  @override
  j.Template load(
    j.Environment environment,
    String path, {
    Map<String, Object?>? globals,
  }) {
    final src = parent[path];
    return src == null
        ? other.load(environment, path)
        : environment.fromString(src, path: path);
  }

  @override
  List<String> listTemplates() => [...parent.keys, ...other.listTemplates()];

  @override
  bool get hasSourceAccess => true;

  @override
  String getSource(String path) => parent[path] ?? other.getSource(path);
}
