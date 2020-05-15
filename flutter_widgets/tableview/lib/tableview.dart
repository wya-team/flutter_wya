library tableview;

import 'package:flutter/material.dart';

typedef SectionHeaderView = Widget Function(BuildContext context, int index);
typedef SectionFooterView = Widget Function(BuildContext context, int index);
typedef NumberRowOfSection = int Function(BuildContext context, int index);
typedef RowView = Widget Function(BuildContext context, int section, int row);

class TableView extends StatefulWidget {
  TableView({
    Key key,
    this.tableHeaderView,
    this.tableFooterView,
    @required this.sectionNumber,
    @required this.numberRowOfSection,
    this.sectionHeaderView,
    this.sectionFooterView,
    @required this.rowView,
    this.scrollController,
  }) : super(key: key);
  /// 表头视图
  final Widget tableHeaderView;
  /// 表尾视图
  final Widget tableFooterView;
  /// 分区个数
  final int sectionNumber;
  /// 区头视图
  SectionHeaderView sectionHeaderView;
  /// 区尾视图
  SectionFooterView sectionFooterView;
  /// 每个区的行数
  NumberRowOfSection numberRowOfSection;
  /// 每行的视图
  RowView rowView;

  ScrollController scrollController;
  
  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  int allCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAllCount();
  }

  @override
  void didUpdateWidget(TableView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    checkAllCount();
  }

  void checkAllCount(){
    allCount = 0;
    if (widget.tableHeaderView != null) {
      allCount += 1;
    }
    allCount += widget.sectionNumber;
    if (widget.tableFooterView != null) {
      allCount += 1;
    }
  }

  Widget sectionView(BuildContext context, int section) {
    List<Widget> rows = [];
    if (widget.sectionHeaderView != null) {
      rows.add(widget.sectionHeaderView(context, section));
    }

    var index = widget.numberRowOfSection(context, section);
    for (var i = 0; i < index; i++) {
      rows.add(widget.rowView(context, section, i));
    }
    if (widget.sectionFooterView != null) {
      rows.add(widget.sectionFooterView(context, section));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (widget.tableHeaderView != null && index == 0) {
          return widget.tableHeaderView;
        }
        if (widget.tableHeaderView != null &&
            widget.tableFooterView != null &&
            index == allCount - 1) {
          return widget.tableFooterView;
        }
        return sectionView(
            context, widget.tableHeaderView != null ? index - 1 : index);
      },
      itemCount: allCount,
    );
  }
}
