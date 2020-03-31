# noticebar

> 自左至右滚动的通知栏

```
NoticeBar({
    this.scrollDirection = Axis.horizontal, // 滚动方向
    this.reverse = false, // 是否反向滚动
    this.leftWidget, // 左侧组件
    this.rightWidget, // 右侧组件
    @required this.textList, // 要滚动的文字，如果是横向滚动显示同一句话的时候，要在外部自己拼装数据
    this.backgroundColor = Colors.white, // 设置背景颜色
  }) : super();
```
