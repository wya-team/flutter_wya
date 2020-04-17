import 'package:flutter/material.dart';

typedef SelectCallback = Function(bool select);

class CheckBoxDescribe extends StatefulWidget {
  CheckBoxDescribe({this.selectCallback, this.describeText});
  SelectCallback selectCallback;
  String describeText;

  @override
  _CheckBoxDescribeState createState() => _CheckBoxDescribeState();
}

class _CheckBoxDescribeState extends State<CheckBoxDescribe> {
  bool isSelct = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Checkbox(value: isSelct, onChanged: (select){
            if (widget.selectCallback != null) {
              widget.selectCallback(select);
            }
            setState(() {
              isSelct = select;
            });
          }),
          Text(widget.describeText),
        ],
      ),
    );
  }
}
