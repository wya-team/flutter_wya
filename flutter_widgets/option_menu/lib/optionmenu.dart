library optionmenu;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optionmenu/option_menu_model.dart';

typedef IndexSourceCallback = OptionMenuModel Function(int index);
typedef ResultSourceCountCallback = int Function(int index);
typedef ResultSourceCallback = Widget Function(int index, int resultIndex);

class OptionMenu extends StatefulWidget {
  OptionMenu({
    this.flex = 1,
    this.menuHeight = 200.0,
    @required this.indexSourceCount,
    @required this.indexSourceCallback,
    @required this.resultSourceCountCallback,
    @required this.resultSourceCallback,
  });

  /// 整体高度
  double menuHeight;
  /// 比例大小
  int flex;
  /// 索引个数
  int indexSourceCount;
  /// 索引数据源
  IndexSourceCallback indexSourceCallback;
  /// 根据索引获取到结果的个数
  ResultSourceCountCallback resultSourceCountCallback;

  ResultSourceCallback resultSourceCallback;

  @override
  _OptionMenuState createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  int _selectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: widget.menuHeight),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var model = widget.indexSourceCallback(index);
                return WYAIOSButton(
                  onPressed: () {
                    setState(() {
                      _selectIndex = index;
                    });
                  },
                  color: Color.fromRGBO(246, 246, 246, 1),
                  selectedColor: Color.fromRGBO(255, 255, 255, 1),
                  isSelected: _selectIndex == index ? true : false,
                  superControl: true,
                  child: Row(
                    children: <Widget>[
                      Text(
                        model.text,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                );
              },
              itemCount: widget.indexSourceCount,
            ),
          ),
          Expanded(
            flex: widget.flex,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return widget.resultSourceCallback(_selectIndex, index);
              },
              itemCount: widget.resultSourceCountCallback(_selectIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class WYAIOSButton extends StatefulWidget {
  WYAIOSButton(
      {@required this.child,
      this.padding,
      this.color,
        this.selectedColor,
      this.disabledColor = CupertinoColors.quaternarySystemFill,
      this.minSize,
      this.borderRadius,
      @required this.onPressed,
      this.isSelected = false,
      this.superControl = false});

  Widget child;

  EdgeInsetsGeometry padding;

  Color color;

  Color selectedColor;

  Color disabledColor;

  double minSize;

  BorderRadius borderRadius;

  /// 点击回调
  VoidCallback onPressed;

  /// 是否选中
  bool isSelected;

  /// 状态是否由父类管理
  bool superControl;

  @override
  _WYAIOSButtonState createState() => _WYAIOSButtonState();
}

class _WYAIOSButtonState extends State<WYAIOSButton> {
  bool select;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    select = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.superControl) {
      select = widget.isSelected;
    }
    return CupertinoButton(
        child: widget.child,
        padding: widget.padding,
        color: select == false
            ? widget.color
            : widget.selectedColor,
        disabledColor: widget.disabledColor,
        minSize: widget.minSize,
        borderRadius: widget.borderRadius,
        onPressed: (){
          setState(() {
            select = !select;
          });
          widget.onPressed();
        },
    );
  }
}