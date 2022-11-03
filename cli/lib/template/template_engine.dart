
import 'package:jinja/jinja.dart' show Environment;

class RenderContext {
  final Map<String, Function> filters;
  final Map<String, dynamic> data;

  const RenderContext({
    required this.filters,
    required this.data,
  });
}

abstract class TemplateEngine {
  factory TemplateEngine(Environment env) = _JinjaTemplate;

  String renderPage(RenderContext context);

  String renderLingualIndex(RenderContext context);
}

class _JinjaTemplate implements TemplateEngine {
  final Environment env;

  _JinjaTemplate(this.env);

  @override
  String renderPage(RenderContext context) {
    env.filters..clear()..addAll(context.filters);
    final data = context.data;
    return env.getTemplate('page.html').render(data);
  }

  @override
  String renderLingualIndex(RenderContext context) {
    env.filters..clear()..addAll(context.filters);
    final data = context.data;
    return env.getTemplate('languages.html').render(data);
  }
}
