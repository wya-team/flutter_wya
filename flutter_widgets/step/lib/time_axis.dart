import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

class TimeAxis extends StatelessWidget {
  Widget child;
  String timeText;
  double left;
  ParagraphStyle paragraphStyle;
  Color textColor;

  TimeAxis(
    this.timeText,
    this.paragraphStyle,
    this.child, {
    Key key,
    this.left = 100,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        str: this.timeText,
        paragraphStyle: this.paragraphStyle,
        textColor: this.textColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: this.left),
        child: this.child,
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  String str;
  ParagraphStyle paragraphStyle;
  TextStyle textStyle;
  Color textColor;
  MyPainter({
    this.str,
    this.paragraphStyle,
    this.textColor,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
//    print(size);
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.red
      ..strokeWidth = 2;
    canvas.drawLine(Offset(50, 25), Offset(50, size.height - 5), paint);

    ParagraphBuilder pb = ParagraphBuilder(this.paragraphStyle)
      ..pushStyle(ui.TextStyle(color: this.textColor))
      ..addText(this.str);
    ParagraphConstraints pc = ParagraphConstraints(width: 50);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(20, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
//    throw UnimplementedError();
    return true;
  }
}
