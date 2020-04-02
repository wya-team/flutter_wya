library round_checkbox;

import 'package:flutter/material.dart';

class RoundCheckBox extends StatefulWidget {
  bool value = false;
  Function(bool) onChanged;

  RoundCheckBox({
    Key key,
    @required this.value,
    this.onChanged
  }) : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            widget.value = !widget.value;
            widget.onChanged(widget.value);
          },
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: widget.value
                ? Icon(
                    Icons.check_circle,
                    size: 20.0,
                    color: Colors.lightBlue,
              textDirection: TextDirection.ltr,
                  )
                : Icon(
                    Icons.panorama_fish_eye,
                    size: 20.0,
                    color: Colors.grey,
              textDirection: TextDirection.ltr,
                  ),
          )),
    );
  }
}
