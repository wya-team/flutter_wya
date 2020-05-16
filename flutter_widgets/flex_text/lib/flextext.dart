import 'package:flutter/material.dart';

class FlexText extends StatefulWidget {
  FlexText({
    Key key,
    this.text,
    this.maxLines,
    this.style,
    this.expand = false,
  }) : super(key: key);

  String text;
  int maxLines;
  TextStyle style;
  bool expand;

  @override
  State<StatefulWidget> createState() {
    return _FlexTextState();
  }
}

class _FlexTextState extends State<FlexText> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: widget.text ?? '', style: widget.style);
      final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr);

      tp.layout(maxWidth: size.maxWidth);
      if (tp.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.expand
                ? Text(widget.text ?? '', style: widget.style)
                : Text(widget.text ?? '',
                maxLines: widget.maxLines,
                overflow: TextOverflow.ellipsis,
                style: widget.style),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  widget.expand = !widget.expand;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 2),
                child: Text(widget.expand ? '收起' : '全文',
                    style: TextStyle(
                        fontSize:
                        widget.style != null ? widget.style.fontSize : null,
                        color: Colors.blue)),
              ),
            ),
          ],
        );
      } else {
        return Text(widget.text ?? '', style: widget.style);
      }
    });
  }
}
