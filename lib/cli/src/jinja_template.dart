part of '../theme_manager.dart';

class _JinjaTemplate implements TemplateEngine {
  final Environment env;

  const _JinjaTemplate(this.env);

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
