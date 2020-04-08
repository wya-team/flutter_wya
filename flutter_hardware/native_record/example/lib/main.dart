import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_record/native_record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            FlatButton(onPressed: (){}, child: Text('开始录音')),
            FlatButton(onPressed: (){}, child: Text('暂停录音')),
            FlatButton(onPressed: (){}, child: Text('结束录音')),
            Text('录音的路径是：'),
            FlatButton(onPressed: (){}, child: Text('开始播放')),
            FlatButton(onPressed: (){}, child: Text('暂停播放')),
            FlatButton(onPressed: (){}, child: Text('结束播放')),
          ],
        ),
      ),
    );
  }
}
