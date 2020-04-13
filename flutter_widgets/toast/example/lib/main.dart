import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  void showLongToast() {
    CustomToast.showToast("This is Long Toast");
  }

  void showColoredToast() {
    CustomToast.showToast(
        "This is Colored Toast with android duration of 5 Sec",
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void showShortToast() {
    CustomToast.showToast("This is Short Toast");
  }

  void showTopShortToast() {
    CustomToast.showToast(
      "This is Top Short Toast",
      gravity: ToastGravity.TOP,
    );
  }

  void showCenterShortToast() {
    CustomToast.showToast(
      "This is Center Short Toast",
      gravity: ToastGravity.CENTER,
    );
  }

  void cancelToast() {
    CustomToast.cancelToast();
  }

  void showLoading() {
    CustomToast.showLoading(
        msg: '加载中...', cancelable: true, canceledOnTouchOutside: true);
  }

  void showSuccess() {
    CustomToast.showLoading(
      msg: '成功',
        cancelable: true, canceledOnTouchOutside: true, status: 1);
  }

  void showFail() {
    CustomToast.showLoading(
        msg: '失败',
        cancelable: true, canceledOnTouchOutside: true, status: -1);
  }

  void cancelLoading() {
    CustomToast.cancelLoading();
  }

  void waringLoading() {
    CustomToast.showLoading(
      msg: '警告',
      status: -2,
      canceledOnTouchOutside: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Toast'),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                    child: new Text('Show Long Toast'),
                    onPressed: showLongToast),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                    child: new Text('Show Short Toast'),
                    onPressed: showShortToast),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                    child: new Text('Show Center Short Toast'),
                    onPressed: showCenterShortToast),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                    child: new Text('Show Top Short Toast'),
                    onPressed: showTopShortToast),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                    child: new Text('Show Colored Toast'),
                    onPressed: showColoredToast),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                  child: new Text('Cancel Toasts'),
                  onPressed: cancelToast,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                  child: new Text('Show Loading'),
                  onPressed: showLoading,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                  child: new Text('Show Success'),
                  onPressed: showSuccess,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                  child: new Text('Show Fail'),
                  onPressed: showFail,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: waringLoading,
                  child: Text('waring Loading'),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: new RaisedButton(
                  child: new Text('Cancel Loading'),
                  onPressed: cancelLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
