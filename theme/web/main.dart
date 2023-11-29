import 'dart:html' show Element, Rectangle, window, document, querySelectorAll;
import 'dart:math' show min, max;

void showTooltip(Element anchor) {
  final screenRect = Rectangle(
    window.screenLeft ?? 0,
    window.screenTop ?? 0,
    window.screen?.width ?? 0,
    window.screen?.height ?? 0,
  );
  final id = anchor.dataset['target'];
  final tooltip = id == null ? null : document.getElementById(id);
  if (tooltip == null) {
    return;
  }
  final anchorAncestor = anchor.offsetParent?.getBoundingClientRect() ?? screenRect;

  final x = min(max(0, (anchor.offsetLeft + anchor.offsetWidth / 2 - tooltip.offsetWidth / 2).toInt()),
      anchorAncestor.right - tooltip.offsetWidth - anchorAncestor.left);
  final y = anchor.offsetTop + anchor.offsetHeight;

  final tooltipAncestor = tooltip.offsetParent?.getBoundingClientRect() ?? screenRect;
  // tooltip's ancestor may not be same with anchor's
  // so calculate the offset position for tooltip
  final dx = anchorAncestor.left - tooltipAncestor.left;
  final dy = anchorAncestor.top - tooltipAncestor.top;

  tooltip.style
    ..visibility = 'visible'
    ..left = '${x + dx}px'
    ..top = '${y + dy}px';

  bool hover = false;
  anchor.onMouseLeave.listen((ev) {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (!hover) {
        tooltip.style.visibility = "hidden";
      }
    });
  });
  tooltip.onMouseEnter.listen((ev) {
    hover = true;
  });
  tooltip.onMouseLeave.listen((ev) {
    hover = false;
    tooltip.style.visibility = "hidden";
  });
}

void main() {
  final items = querySelectorAll('.glossary-item');
  for (final anchor in items) {
    anchor.onMouseEnter.listen((e) {
      showTooltip(anchor);
    });
  }
}
