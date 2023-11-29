
import 'package:jinja/jinja.dart' show Environment, Loader, Template;

class TemplateLoader extends Loader {
  final Map<String, String> parent;
  final Loader other;

  TemplateLoader(this.parent, this.other);

  @override
  Template load(Environment environment, String path) {
    final src = parent[path];
    return src == null ? other.load(environment, path)
        : environment.fromString(src, path: path);
  }

  @override
  List<String> listTemplates() => [
    ...parent.keys,
    ...other.listTemplates(),
  ];

  @override
  bool get hasSourceAccess => true;

  @override
  String getSource(String path) => parent[path] ?? other.getSource(path);
}
