import 'dart:html';
import 'dart:math';

void showTooltip(Element anchor, {int? width, int? height}) {
  final id = 'tooltip-box-${anchor.id}';
  final box = document.getElementById(id)!;
  box.style.display = 'block';
  if (box.parent != anchor) {
    box.remove();
    anchor.append(box);

    final left = anchor.offsetLeft;
    final top = anchor.offsetTop;
    final parent = document.getElementById('container');

    final right = parent != null ? (parent.offsetLeft + parent.offsetWidth) : document.body!.clientWidth;
    final x = max(0, min(left + (anchor.clientWidth >> 2) - (box.offsetWidth >> 2), right - box.offsetWidth));
    print("parent=(${parent?.offsetLeft}, ${parent?.offsetWidth}), "
        "anchor=(${anchor.offsetLeft}, ${anchor.offsetWidth}), "
        "box=(${box.offsetLeft}, ${box.offsetWidth}), "
        "right=$right, x=$x");
    final y = top + anchor.offsetHeight;
    box.style..left = '${x}px'
      ..top = '${y}px';
    anchor.onMouseLeave.listen((ev) {
      Future.delayed(Duration(milliseconds: 20), () {
        box.style.display = "none";
      });
    });
  }
}

void main() {
  final output = querySelector('#output')!;
  output.innerHtml = 'Your Dart app is <a id="anchor">running</a>.';
  final anchor = querySelector('#anchor');
  if (anchor != null) {
    anchor.onMouseEnter.listen((e) {
      showTooltip(anchor);
    });
  }
}
