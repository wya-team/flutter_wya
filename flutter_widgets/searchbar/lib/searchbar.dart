import 'package:flutter/material.dart';

/// center 图标居中
/// normal普通的搜索框
/// cancel 包含取消按钮的搜索框
enum SearchBarType { center, normal, cancel }

class SearchBar extends StatefulWidget {
  /// 是否可以输入默认允许输入
  final bool enabled;

  /// 是否显示左侧按钮
  final bool hideLeft;

  /// 搜索类型，默认为普通类型
  final SearchBarType searchBarType;

  /// 占位文字
  final String hint;

  /// 默认文字
  final String defaultText;

  /// 左侧按钮点击事件
  final void Function() leftButtonClick;

  /// 右侧按钮点击事件
  final void Function() rightButtonClick;

  /// 输入框点击事件
  final void Function() inputBoxClick;

  /// 输入框内文字变化
  final ValueChanged<String> onChanged;

  /// 输入框颜色默认为白色
  final Color inputBoxColor;

  /// 搜索按钮图标颜色
  final Color searchIconColor;

  /// 高度默认28
  final double height;

  /// 圆角值
  final double borderRadius;

  /// 设置了高度需要调整输入内容的文字位置
  final EdgeInsetsGeometry countPadding;

  const SearchBar(
      {this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.inputBoxClick,
      this.onChanged,
      this.inputBoxColor = Colors.white,
      this.height = 32,
      this.searchIconColor = Colors.grey,
      this.countPadding,
      this.borderRadius = 5});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool switchInputBox = false;

  /// 是否展示删除按钮
  bool showClear = false;

  /// 控制器
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchBarType == SearchBarType.center) {
      return _getCenterSearch();
    } else if (widget.searchBarType == SearchBarType.cancel) {
      return _getCancelSearch();
    }
    return _getNormalSearch();
  }

  /// 普通的搜索框
  _getNormalSearch() {
    return Container(
      height: widget.height + 12,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          _wrapTap(_getLeftWidget(), widget.leftButtonClick),
          Expanded(flex: 1, child: _inputBox()),
        ],
      ),
    );
  }

  /// 带取消按钮的搜索框
  _getCancelSearch() {
    return Container(
      height: widget.height + 12,
      padding: EdgeInsets.only(left: 10, right: 15),
      child: Row(
        children: <Widget>[
          _wrapTap(_getLeftWidget(), widget.leftButtonClick),
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  /// 居中显示的搜索框
  _getCenterSearch() {
    return Container(
      height: widget.height + 12,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          _wrapTap(_getLeftWidget(), widget.leftButtonClick),
          Expanded(flex: 1, child: _inputCenterBox()),
        ],
      ),
    );
  }

  /// 居中的输入框
  _inputCenterBox() {
    return Container(
      height: widget.height,
      padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
          color: widget.inputBoxColor,
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: _getTextFieldCenter(),
    );
  }

  /// 获取居中搜索框的输入框
  _getTextFieldCenter() {
    return switchInputBox
        ? Row(
            children: <Widget>[
              _getSearchIcon(),
              _getTextField(),
              _getClearIcon(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getSearchIcon(),
              _wrapTap(
                  Container(
                    child: Text(
                      widget.hint ?? '搜索',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ), () {
                // 切换为normal输入框
                setState(() {
                  switchInputBox = !switchInputBox;
                });
              })
            ],
          );
  }

  /// 返回拥有点击回调的一个组件
  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: child,
    );
  }

  /// 是否显示左侧返回按钮返回组件
  _getLeftWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
      child: widget?.hideLeft ?? true
          ? null
          : Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 26,
            ),
    );
  }

  /// 搜索输入框
  _inputBox() {
    return Container(
      height: widget.height,
      padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
          color: widget.inputBoxColor,
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getSearchIcon(),
          _getTextField(),
          _getClearIcon(),
        ],
      ),
    );
  }

  /// 搜索图标
  _getSearchIcon() {
    return Icon(
      Icons.search,
      size: 20,
      color: widget.searchIconColor,
    );
  }

  /// 输入框
  _getTextField() {
    return Expanded(
        flex: 1,
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          autofocus: true,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),

          /// 输入文本样式
          decoration: InputDecoration(
            // flutter sdk >= v1.12.1输入框样式匹配,文字之间的间距
            contentPadding: EdgeInsets.all(widget.height / 4.0),
            // 取去除下划线
            border: InputBorder.none,
            // 设置默认的占位文字为搜索
            hintText: widget.hint ?? '搜索',
            hintStyle: TextStyle(fontSize: 15),
          ),
        ));
  }

  /// 清空按钮
  _getClearIcon() {
    return !showClear
        ? Text('')
        : _wrapTap(
            Icon(
              Icons.clear,
              size: 20,
              color: Colors.grey,
            ), () {
            setState(() {
              _controller.clear();
            });
            _onChanged('');
          });
  }

  /// 文字改变
  _onChanged(String text) {
    /// 当输入框文字大于0显示删除按钮
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }
}
