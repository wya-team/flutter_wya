import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:native_camera/native_camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Uint8List _uint8list = Uint8List(1);

  @override
  void initState() {
    super.initState();
  }

  void openCamera() async {
    Map<String, dynamic> map = await NativeCamera.openCamera();
    print(map);
    base642Image(map["imageBase64"]);
  }

  void base642Image(String base64Txt) async {
    Uint8List list =  convert.base64.decode(base64Txt);
    setState(() {
      _uint8list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
            RaisedButton(onPressed: openCamera, child: Text('打开摄像头')),
            Image.memory(_uint8list),
            ],
          ),
        ),
      ),
    );
  }
}
