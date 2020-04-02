import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

enum TimeAxisStyle {
  // 文本类型
  text,
  // 纯色圆形
  circular,
}

class TimeAxis extends StatelessWidget {
  TimeAxis({
    Key key,
    this.style = TimeAxisStyle.text,
    this.timeText,
    this.textColor = Colors.black,
    this.paragraphStyle,
    this.left = 100,
    this.needLine,
    this.child,
  }) : super(key: key);

  /// 设置时间轴样式
  TimeAxisStyle style;

  /// 当style为text样式时，绘制在左侧的文本
  String timeText;

  /// 当style为text样式时，文本字体颜色
  Color textColor;

  /// 当style为text样式时，设置文本装饰属性
  ParagraphStyle paragraphStyle;

  /// 设置左侧占据多少距离
  double left;

  /// 是否需要线条
  bool needLine;

  /// 右侧子组件
  Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        str: this.timeText,
        paragraphStyle: this.paragraphStyle,
        textColor: this.textColor,
        width: this.left,
        style: this.style,
        needLine: this.needLine,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: this.left),
        child: this.child,
      ),
    );
  }
}

class MyPainter extends CustomPainter {

  MyPainter({
    this.style,
    this.str,
    this.paragraphStyle,
    this.textColor,
    this.width,
    this.needLine,
  }) : super();

  String str;
  ParagraphStyle paragraphStyle;
  TextStyle textStyle;
  Color textColor;
  double width;
  TimeAxisStyle style;
  bool needLine;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    if(this.style == TimeAxisStyle.text) {
      ParagraphBuilder pb = ParagraphBuilder(this.paragraphStyle)
        ..pushStyle(ui.TextStyle(color: this.textColor))
        ..addText(this.str);
      ParagraphConstraints pc = ParagraphConstraints(width: this.width);
      Paragraph paragraph = pb.build()..layout(pc);
      canvas.drawParagraph(paragraph, Offset(0, 0));
    } else if (this.style == TimeAxisStyle.circular) {
      var circlePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = Colors.red;

      canvas.drawCircle(Offset((this.width - 2)/2,10), 10, circlePaint);
    }

    if(this.needLine) {
      var paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = Colors.red
        ..strokeWidth = 2;

      canvas.drawLine(Offset(this.width/2 - 1, 20), Offset(this.width/2 - 1, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
//    throw UnimplementedError();
    return true;
  }
}
