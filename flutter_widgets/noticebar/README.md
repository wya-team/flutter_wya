# noticebar

> 自左至右滚动的通知栏

```
NoticeBar({
    this.leftWidget, // 左边的组件
    this.rightWidget, // 右边的组件
    @required this.text,
    this.type = NoticeType.constant, // 动画方式
    this.backgroundColor = Colors.white,  // 背景颜色
  }) : super();
```
