import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_gallery/native_gallery.dart';
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _childs = [];

  @override
  void initState() {
    super.initState();
  }

  void openAlbum() async {
    Map<dynamic, dynamic> map = await NativeGallery.openAlbum(
        maxSelectCount: 5,
        allowSelectOriginal: false,
        canTakePicture: false,
        allowEditImage: true,
        allowSelectVideo: false,
        allowChoosePhotoAndVideo: false);
    print(map);
    List<Widget> wids = [];
    List list = map["images"];
    list.forEach((element) async {
      Uint8List list = await base642Image(element);
      wids.add(SizedBox(
        width: 100,
        height: 100,
        child: Image.memory(list),
      ));
    });
    setState(() {
      _childs = wids;
    });
  }

  Future<Uint8List> base642Image(String base64Txt) async {
    Uint8List list = convert.base64.decode(base64Txt);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: openAlbum,
              child: Text('打开相册'),
            ),
            Wrap(
              children: _childs,
            )
          ],
        ),
      ),
    );
  }
}
