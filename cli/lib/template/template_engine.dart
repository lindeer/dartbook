
import 'package:jinja/jinja.dart' show Environment;

abstract class TemplateEngine {
  factory TemplateEngine(Environment env) = _JinjaTemplate;

  String renderPage(Map<String, dynamic> data);

  String renderLingualIndex(Map<String, dynamic> data);
}

class _JinjaTemplate implements TemplateEngine {
  final Environment env;

  _JinjaTemplate(this.env);

  @override
  String renderPage(Map<String, dynamic> data) {
    return env.getTemplate('page.html').render(data);
  }

  @override
  String renderLingualIndex(Map<String, dynamic> data) {
    return env.getTemplate('languages.html').render(data);
  }
}
