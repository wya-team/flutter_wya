import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  /// 占位文字组件
  final Text title;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final TextStyle style;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;
  /// 边框色
  final Color borderColor;

  /// 光标颜色
  final Color cursorColor;

  SearchBar(
      {@required this.title,
      this.height = 44,
      this.width,
      this.borderColor = Colors.white,
      this.cursorColor ,
      this.borderWidth,
      this.borderRadius,
      this.margin,
      this.padding, this.style, this.onChanged, this.onSubmitted, this.onEditingComplete});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _isEdit = false;
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        child: _isEdit ? _getEditWidget() : _getNormalWidget());
  }

  Widget _getEditWidget() {
    return TextField(
      textInputAction:TextInputAction.search,
      autofocus: true,
      style: widget.style,
      focusNode: _focusNode,
      controller: controller,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey,),
          hintText: widget.title.data,
          suffixIcon: isShowClean ? IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: onCancel()) : Text(''),
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

  Widget _getNormalWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEdit = !_isEdit;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.grey,
          ),
           widget.title,
        ],
      ),
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

