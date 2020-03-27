## TableView
> 与iOS端的table一致，可以很快的构建分区，分行的列表视图

```java
TableView({
    Key key,
    this.tableHeaderView,
    this.tableFooterView,
    @required this.sectionNumber,
    @required this.numberRowOfSection,
    this.sectionHeaderView,
    this.sectionFooterView,
    @required this.rowView,
})
```

- tableHeaderView -> Widget :  列表头部视图
- tableFooterView -> Widget :  列表尾部视图
- sectionNumber -> int : 分区个数
- numberRowOfSection -> int Function(BuildContext context, int index) : 每个区有多少行
- sectionHeaderView -> Widget Function(BuildContext context, int index) : 分区的区头视图
- sectionFooterView -> Widget Function(BuildContext context, int index) : 分区的区尾视图
- rowView -> Widget Function(BuildContext context, int section, int row) : 每一行的视图