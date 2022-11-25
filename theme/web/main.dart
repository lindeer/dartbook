import 'dart:html';

void showTooltip(Element anchor, String id, String html, {int? width, int? height}) {
  final e = document.getElementById(id);
  if (e != null) {
    e.style.display = 'block';
  } else {
    final box = document.createElement('div')
      ..id = id
      ..className = 'tooltip-shadow'
      ..innerHtml = html;
    anchor.append(box);
    box.style
      ..width = width == null ? 'auto' : '${width}px'
      ..height = height == null ? 'auto' : '${height}px'
      ..position = 'absolute'
      ..display = 'block';

    final left = anchor.offsetLeft;
    final top = anchor.offsetTop;
    final maxWidth = anchor.parent?.clientWidth ?? document.body!.clientWidth;
    final x = left + (anchor.offsetHeight >> 2) - (box.offsetWidth >> 2);
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
      showTooltip(anchor, "tooltip", "<h2>JavaScript的5种基本数据类型：</h2><p>Undefined</p><p>Null</p><p>Boolean</p><p>Number</p><p>String</p>");
    });
  }
}
