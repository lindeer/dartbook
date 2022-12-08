import 'dart:html';
import 'dart:math';

void showTooltip(Element anchor, {int? width, int? height}) {
  final box = anchor.children.first;
  if (box.style.visibility != 'visible') {
    box.style.visibility = 'visible';
    final left = anchor.offsetLeft;
    final top = anchor.offsetTop;
    final parent = document.querySelector('.markdown-section');

    final right = parent != null ? (parent.offsetLeft + parent.offsetWidth) : document.body!.clientWidth;
    final x = max(0, min(left + anchor.clientWidth / 2 - box.offsetWidth / 2, right - box.offsetWidth)).toInt();
    print("parent=(${parent?.offsetLeft}, ${parent?.offsetWidth}), "
        "anchor=(${anchor.offsetLeft}, ${anchor.offsetWidth}), "
        "box=(${box.offsetLeft}, ${box.offsetWidth}), "
        "right=$right, x=$x");
    final y = top + anchor.offsetHeight;
    box.style..left = '${x}px'
      ..top = '${y}px';
    anchor.onMouseLeave.listen((ev) {
      Future.delayed(Duration(milliseconds: 20), () {
        box.style.visibility = 'hidden';
      });
    });
  }
}

void main() {
  final items = querySelectorAll('.glossary-item');
  for (final anchor in items) {
    anchor.onMouseEnter.listen((e) {
      showTooltip(anchor);
    });
  }
}
