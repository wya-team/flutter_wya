import 'package:flutter/material.dart';

class LinearProgressViewWidget extends StatelessWidget {
  LinearProgressViewWidget(
      {this.backgroundColor = const Color(0xFFEEEEEE),
      this.value,
      this.height,
      this.width,
      this.valueColor = const Color(0xFFFF0000),
      this.type = 0});

  final int type;

  /// 粗细
  final double height;

  /// 圆的半径
  final double width;

  /// 当前进度，取值范围 [0.0-1.0]
  final double value;

  /// 进度条背景色
  final Color backgroundColor;

  /// 进度条颜色
  final Color valueColor;

  // 动画相关控制器与补间。
  AnimationController animation;
  Tween<double> tween;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          //限制进度条的高度
          height: height,
          //限制进度条的宽度
          width: width,
          child: ClipRRect(
            // 边界半径（`borderRadius`）属性，圆角的边界半径。
            borderRadius: BorderRadius.all(Radius.circular(width)),
            child: new LinearProgressIndicator(
                //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                value: value,
                //背景颜色
                backgroundColor: backgroundColor,
                //进度颜色
                valueColor: new AlwaysStoppedAnimation<Color>(valueColor)),
          ),
        ),
        Stack(
          children: <Widget>[
            Visibility(
              visible: type == 0 ? true : false,
              child: Text((value * 100).toString() + "%"),
            ),
            Visibility(
              visible:  type == 1 ? true : false,
              child: new Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
            Visibility(
              visible:  type == 2 ? true : false,
              child: new Icon(
                Icons.insert_emoticon,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
