import 'package:flutter/material.dart';

class SearchBarCenter extends StatefulWidget {
  /// 占位文字组件
  final Text title;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  /// 边框色
  final Color borderColor;

  /// 光标颜色
  final Color cursorColor;
  final TextStyle style;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;
  SearchBarCenter({@required this.title,
    this.height = 44,
    this.width,
    this.borderColor = Colors.white,
    this.cursorColor,
    this.borderWidth,
    this.borderRadius,
    this.margin,
    this.padding, this.onChanged, this.onSubmitted, this.style, this.onEditingComplete});

  @override
  _SearchBarCenterState createState() => _SearchBarCenterState();
}


class _SearchBarCenterState extends State<SearchBarCenter> {
  bool isShowClean = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListenner);
  }

  Future _focusNodeListenner() async {
    if (_focusNode.hasFocus) {
      setState(() {
        isShowClean = true;
      });
    } else {
      setState(() {
        isShowClean = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.title != null);
    return Container(
        margin: widget.margin,
        padding: widget.padding,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor, width: widget.borderWidth),
            borderRadius:
            BorderRadius.all(Radius.circular(widget.borderRadius)),
            color: Colors.white),
        child: _getEditWidget());
  }

  Widget _getEditWidget() {
    return TextField(
      textInputAction:TextInputAction.search,
      style: widget.style,
      focusNode: _focusNode,
      controller: controller,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey,),
          hintText: widget.title.data,
          suffixIcon: isShowClean ? IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: (){
                onCancel();
              }) : Text(''),
          border: InputBorder.none
      ),

      onSubmitted: (value) {
        widget.onSubmitted(value);
      },

      onChanged: (text) {
        widget.onChanged(text);
      },
      //按回车时调用
      onEditingComplete: (){
        widget.onEditingComplete();
      },
    );
  }

  onCancel() {
    controller.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.clear());
    setState(() {
      isShowClean = false;
    });
  }

}
