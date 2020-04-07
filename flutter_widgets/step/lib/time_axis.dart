import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

enum TimeAxisStyle {
  // 纯色圆形
  circular,
  // 文本类型
  text,
}

class TimeAxis extends StatelessWidget {
  TimeAxis({
    Key key,
    this.direction = Axis.vertical,
    this.style = TimeAxisStyle.circular,
    this.timeText,
    this.textColor = Colors.black,
    this.paragraphStyle,
    this.left = 100,
    this.verticalNeedLine = true,
    this.horizontalNeedLeftLine,
    this.horizontalNeedRightLine,
    this.fillColor = Colors.red,
    this.child,
  }) : super(key: key);

  /// 时间轴方向
  Axis direction;

  /// 设置时间轴样式
  TimeAxisStyle style;

  /// 当style为text样式时，绘制在左侧的文本
  String timeText;

  /// 当style为text样式时，文本字体颜色
  Color textColor;

  /// 当style为text样式时，设置文本装饰属性
  /// 当direction是vertical时，style为text时，请设置属性textAlign为left,这样可以计算出绘制的文字占据的内容宽度
  ParagraphStyle paragraphStyle;

  /// 当direction是vertical时，设置左侧占据多少距离
  /// 当direction是horizontal时，设置子组件的整体宽度一致
  double left;

  /// 是否需要线条
  /// 当direction是vertical时,该属性有用
  bool verticalNeedLine;

  /// 是否需要线条
  /// 两个属性分别控制是否绘制左侧或者右侧的线条
  /// 当direction是horizontal时，该属性有效
  bool horizontalNeedLeftLine;
  bool horizontalNeedRightLine;

  /// 线条颜色，圆形颜色
  /// 默认是Colors.red
  Color fillColor;

  /// 当direction是vertical时，右侧子组件
  /// 整体高度可以子组件内容填充也可以是设置子组件大小
  /// 当direction是horizontal时，下侧子组件
  /// 整体高度由子组件填充
  Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MyPainter(
        direction: this.direction,
        str: this.timeText,
        paragraphStyle: this.paragraphStyle,
        textColor: this.textColor,
        width: this.left,
        style: this.style,
        verticalNeedLine: this.verticalNeedLine,
        horizontalNeedLeftLine: this.horizontalNeedLeftLine,
        horizontalNeedRightLine: this.horizontalNeedRightLine,
        fillColor: this.fillColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: this.direction == Axis.vertical ? this.left : 0,
          top: this.direction == Axis.horizontal ? 50 : 0,
        ),
        child: this.child,
      ),
    );
  }
}

class _MyPainter extends CustomPainter {

  _MyPainter({
    this.direction,
    this.style,
    this.str,
    this.paragraphStyle,
    this.textColor,
    this.width,
    this.verticalNeedLine,
    this.horizontalNeedLeftLine,
    this.horizontalNeedRightLine,
    this.fillColor,
  }) : super();

  Axis direction;
  String str;
  ParagraphStyle paragraphStyle;
  TextStyle textStyle;
  Color textColor;
  double width;
  TimeAxisStyle style;
  bool verticalNeedLine;
  bool horizontalNeedLeftLine;
  bool horizontalNeedRightLine;
  Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    double minTextWidth;
    if(this.style == TimeAxisStyle.text) {
      ParagraphBuilder pb = ParagraphBuilder(this.paragraphStyle)
        ..pushStyle(ui.TextStyle(color: this.textColor))
        ..addText(this.str);
      ParagraphConstraints pc = ParagraphConstraints(width: this.width);
      Paragraph paragraph = pb.build()..layout(pc);
      if (this.direction == Axis.vertical) {
        canvas.drawParagraph(paragraph, Offset(0, 0));
      } else {
        minTextWidth = paragraph.minIntrinsicWidth;
        canvas.drawParagraph(paragraph, Offset((this.width - minTextWidth)/2, 12));
      }

    } else if (this.style == TimeAxisStyle.circular) {
      var circlePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = this.fillColor;
      if (this.direction == Axis.vertical) {
        canvas.drawCircle(Offset((this.width - 2)/2,10), 10, circlePaint);
      } else {
        canvas.drawCircle(Offset((this.width - 2)/2,20), 10, circlePaint);
      }

    }

    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = this.fillColor
      ..strokeWidth = 2;

    if (this.direction == Axis.vertical) {
      if (this.verticalNeedLine) {
        canvas.drawLine(Offset(this.width/2 - 1, 20), Offset(this.width/2 - 1, size.height), paint);
      }
    } else {
      if (this.style == TimeAxisStyle.text) {
        if (this.horizontalNeedLeftLine) {
          canvas.drawLine(Offset(0, 20), Offset((this.width - minTextWidth)/2, 20), paint);
        }
        if (this.horizontalNeedRightLine) {
          canvas.drawLine(Offset((this.width + minTextWidth)/2, 20), Offset(this.width, 20), paint);
        }
      } else {
        if (this.horizontalNeedLeftLine) {
          canvas.drawLine(Offset(0, 20), Offset(this.width/2-10, 20), paint);
        }
        if (this.horizontalNeedRightLine) {
          canvas.drawLine(Offset(this.width/2+10, 20), Offset(this.width, 20), paint);
        }
      }
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
//    throw UnimplementedError();
    return true;
  }
}
