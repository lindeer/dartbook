
class RenderContext {
  final Map<String, Function> filters;
  final Map<String, dynamic> data;

  const RenderContext({
    required this.filters,
    required this.data,
  });
}

abstract class TemplateEngine {

  String renderPage(RenderContext context);

  String renderLingualIndex(RenderContext context);
}
