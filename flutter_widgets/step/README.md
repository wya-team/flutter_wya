#### structure

```
TimeAxis({
    Key key,
    this.direction = Axis.vertical, // 主轴方向
    this.style = TimeAxisStyle.text, // 绘制类型
    this.timeText, // 绘制的文本，在TimeAxisStyle.text有效
    this.textColor = Colors.black, // 绘制文本的颜色
    this.paragraphStyle, // 绘制文本的属性
    this.left = 100, // 当direction是vertical时，设置左侧占据多少距离、当direction是horizontal时，设置子组件的整体宽度一致
    this.verticalNeedLine = true, // 是否需要线条、当direction是vertical时,该属性有用
    this.horizontalNeedLeftLine, // 是否需要左侧线条、当direction是horizontal时，该属性有效
    this.horizontalNeedRightLine, // 是否需要右侧线条、当direction是horizontal时，该属性有效
    this.fillColor = Colors.red, // 绘制线条和圆形的颜色
    this.child, // 子组件 当direction是vertical时，右侧子组件、整体高度可以子组件内容填充也可以是设置子组件大小。当direction是horizontal时，下侧子组件、整体高度由子组件填充
  }) : super(key: key);
```


