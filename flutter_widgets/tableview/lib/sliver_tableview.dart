import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef SectionHeaderView = Widget Function(BuildContext context, int index);
typedef SectionFooterView = Widget Function(BuildContext context, int index);
typedef NumberRowOfSection = int Function(BuildContext context, int index);
typedef RowView = Widget Function(BuildContext context, int section, int row);

class SliverTableView extends SliverList {
  SliverTableView({
    this.delegate,
  }) : super(delegate: delegate);

  SliverTableDelegate delegate;

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
    context as SliverMultiBoxAdaptorElement;
    return RenderSliverList(childManager: element);
  }
}

class SliverTableDelegate extends SliverChildDelegate {
  SliverTableDelegate(
      {this.tableHeaderView,
        this.tableFooterView,
        @required this.sectionNumber,
        this.sectionHeaderView,
        this.sectionFooterView,
        @required this.numberRowOfSection,
        @required this.rowView})
      : assert(numberRowOfSection != null),
        assert(rowView != null);

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

  int allCount = 0;

  void checkAllCount() {
    if (this.tableHeaderView != null) {
      allCount += 1;
    }
    allCount += this.sectionNumber;
    if (this.tableFooterView != null) {
      allCount += 1;
    }
  }

  Widget sectionView(BuildContext context, int section) {
    List<Widget> rows = [];
    if (this.sectionHeaderView != null) {
      rows.add(this.sectionHeaderView(context, section));
    }

    var index = this.numberRowOfSection(context, section);
    for (var i = 0; i < index; i++) {
      rows.add(this.rowView(context, section, i));
    }
    if (this.sectionFooterView != null) {
      rows.add(this.sectionFooterView(context, section));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context, int index) {
    print('index:'+ index.toString());
    checkAllCount();
    if (index < 0 || (allCount != null && index >= allCount))
      return null;

    // TODO: implement build
    if (this.tableHeaderView != null && index == 0) {
      return this.tableHeaderView;
    }
    if (this.tableHeaderView != null &&
        this.tableFooterView != null &&
        index == allCount - 1) {
      return this.tableFooterView;
    }
    return sectionView(
        context, this.tableHeaderView != null ? index - 1 : index);
//    throw UnimplementedError();
  }

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
//    throw UnimplementedError();
  }
}
