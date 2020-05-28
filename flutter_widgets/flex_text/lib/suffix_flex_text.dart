import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SuffixFlexText extends StatefulWidget {
  SuffixFlexText({
    Key key,
    this.textList,
    this.maxLines,
    this.style,
    this.expand = false,
    this.textSpan,
  }) : super(key: key);

  List<String> textList;
  int maxLines;
  TextStyle style;
  bool expand;
  TextSpan textSpan;

  @override
  _SuffixFlexTextState createState() => _SuffixFlexTextState();
}

class _SuffixFlexTextState extends State<SuffixFlexText> {
  TextSpan textS;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textS = widget.textSpan;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
//      final span = TextSpan(children: [
//        widget.textSpan,
//        TextSpan(text: '...展开', style: TextStyle(color: Colors.blue))
//      ]);
      final tp = TextPainter(
          text: widget.textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);
//      print('tp.didExceedMaxLines==${tp.didExceedMaxLines}');
      if (tp.didExceedMaxLines) {
        var otherCount = 0;
        for (int a = 0; a < widget.textList.length - 1; a++) {
          String text = widget.textList[a];
          otherCount += text.length;
        }
        bool isHaveNewLine = false;
        var startIndex = 0;
        for (int count = 0; count < widget.maxLines; count++) {
          TextRange range =
          tp.getLineBoundary(TextPosition(offset: startIndex));
          if (count == widget.maxLines - 1) {
            startIndex = range.end;
            if (range.isCollapsed == true) {
              // 存在换行符
              isHaveNewLine = true;
            }
          } else {
            startIndex = range.end + 1;
          }
        }
//        print('end==${startIndex}');
        String result = '';
        if (isHaveNewLine == true) {
          result =
              widget.textList.last.substring(0, startIndex - otherCount);
        } else {
          result =
              widget.textList.last.substring(0, startIndex - otherCount - 4);
        }

//        print("string==" + result);
        if (widget.textSpan.children != null && widget.textSpan.children.length > 0) {
          List<InlineSpan> spanList = [];
          widget.textSpan.children.forEach((element) {
            spanList.add(element);
          });
          textS = TextSpan(
            children: spanList,
          );
          textS.children.replaceRange(
              textS.children.length - 1,
              textS.children.length,
              [TextSpan(text: result, style: widget.style)]);
        } else {
          textS = TextSpan(
            text: result,
            style: widget.textSpan.style,
            recognizer: widget.textSpan.recognizer,
          );
        }
        TapGestureRecognizer tap = TapGestureRecognizer();
        tap.onTap = () {
          setState(() {
            widget.expand = !widget.expand;
          });
        };
//        print('width.expand==${widget.expand}');
        return widget.expand == false
            ? Text.rich(
          TextSpan(children: [
            textS,
            TextSpan(
                text: '...展开',
                style: TextStyle(color: Colors.blue),
                recognizer: tap),
          ]),
          maxLines: widget.maxLines,
        )
            : Text.rich(
          TextSpan(children: [
            widget.textSpan,
            TextSpan(
                text: ' 收起',
                style: TextStyle(color: Colors.blue),
                recognizer: tap),
          ]),
        );
      } else {
        return Text.rich(widget.textSpan);
      }
    });
  }
}