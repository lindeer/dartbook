
import 'package:jinja/jinja.dart' show Environment, Loader, Template;

class TemplateLoader extends Loader {
  final Map<String, String> parent;
  final Loader other;

  TemplateLoader(this.parent, this.other);

  @override
  Template load(Environment environment, String template) {
    final src = parent[template];
    return src == null ? other.load(environment, template)
        : environment.fromString(src, path: template);
  }

  @override
  List<String> listTemplates() => [
    ...parent.keys,
    ...other.listTemplates(),
  ];

  @override
  bool get hasSourceAccess => true;

  @override
  String getSource(String template) => parent[template] ?? other.getSource(template);
}
