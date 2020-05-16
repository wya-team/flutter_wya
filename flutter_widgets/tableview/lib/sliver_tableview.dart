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

int _lshDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class SliverTableDelegate extends SliverChildDelegate {
  SliverTableDelegate({
    this.tableHeaderView,
    this.tableFooterView,
    @required this.sectionNumber,
    this.sectionHeaderView,
    this.sectionFooterView,
    @required this.numberRowOfSection,
    @required this.rowView,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _lshDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0
  })
      : assert(numberRowOfSection != null),
        assert(rowView != null),
        assert(addAutomaticKeepAlives != null),
        assert(addRepaintBoundaries != null),
        assert(addSemanticIndexes != null);


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

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int semanticIndexOffset;
  final SemanticIndexCallback semanticIndexCallback;

  int checkAllCount() {
    int allCount = 0;
    if (this.tableHeaderView != null) {
      allCount += 1;
    }
    allCount += this.sectionNumber;
    if (this.tableFooterView != null) {
      allCount += 1;
    }
    return allCount;
  }

  Widget sectionView(BuildContext context, int section) {
    List<Widget> rows = [];
    var index = this.numberRowOfSection(context, section);
    if (this.sectionHeaderView == null &&
        this.sectionFooterView == null &&
        index == 0) {
      return null;
    }

    if (this.sectionHeaderView != null) {
      rows.add(this.sectionHeaderView(context, section));
    }

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
  int get estimatedChildCount {
    return checkAllCount();
  }

  @override
  Widget build(BuildContext context, int index) {
//    print('index:'+ index.toString());
    int count = checkAllCount();
    if (index < 0 || (count != null && index >= count)) return null;

    Widget child;
    try {
      if (this.tableHeaderView != null && index == 0) {
        child = this.tableHeaderView;
      } else if (this.tableHeaderView != null &&
          this.tableFooterView != null &&
          index == count - 1) {
        child = this.tableFooterView;
      } else {
        child = sectionView(
            context, this.tableHeaderView != null ? index - 1 : index);
      }
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }
    if (child == null)
      return null;
    final Key key = child.key != null ? _MySaltedValueKey(child.key) : null;

    if (addRepaintBoundaries) child = RepaintBoundary(child: child);
    if (addSemanticIndexes) {
      final int semanticIndex = semanticIndexCallback(child, index);
      if (semanticIndex != null)
        child = IndexedSemantics(
            index: semanticIndex + semanticIndexOffset, child: child);
    }
    if (addAutomaticKeepAlives) child = AutomaticKeepAlive(child: child);
    return KeyedSubtree(child: child, key: key);
  }

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
//    throw UnimplementedError();
  }

  Widget _createErrorWidget(dynamic exception, StackTrace stackTrace) {
    final FlutterErrorDetails details = FlutterErrorDetails(
      exception: exception,
      stack: stackTrace,
      library: 'widgets library',
      context: ErrorDescription('building'),
    );
    FlutterError.reportError(details);
    return ErrorWidget.builder(details);
  }
}

class _MySaltedValueKey extends ValueKey<Key>{
  const _MySaltedValueKey(Key key): assert(key != null), super(key);
}