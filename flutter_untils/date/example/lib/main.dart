import 'package:date/date.dart';
import 'package:date/formats.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var now;
  var date1;
  var date2;
  var date3;

  @override
  void initState() {
    super.initState();
    showView();
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
              Text('当前时间是：$now'),
              Text('当前时间戳：$date1'),
              Text('时间戳转日期：$date2'),
              Text('拼接成date:$date3'),
              Text('date是否在现在之前:' + Date.isBefore(date3).toString()),
              Text('date是否在现在之后:' + Date.isAfter(date3).toString()),
              Text('date是否是现在:' + Date.isAtSameMomentAs(date3).toString()),
              Text('现在加5天：' +
                  Date.fiftyDaysFromNow(now, new Duration(days: 5)).toString()),
              Text('现在减5天：' +
                  Date.fiftyDaysAgo(now, new Duration(days: 5)).toString()),
              Text('比较两个时间 差 小时数：' +
                  Date.compare(
                          now, Date.fiftyDaysAgo(now, new Duration(days: 5)))
                      .toString()),
              Text('获取年月日,时分秒：' +
                  Date.getYear() +
                  "-" +
                  Date.getMonth() +
                  "-" +
                  Date.getDay() +
                  " " +
                  Date.getHour() +
                  ":" +
                  Date.getMinute() +
                  ":" +
                  Date.getSecond()),
              Text('星期：' + Date.getWeekDay()), // 返回星期几
              Text('默认：1993-04-28 05:16:51：' +
                  Date.getFormatDate(Date.getNowTimeStamp())),
              Text('1993-04-28 05:16:51：' +
                  Date.getFormatDate(Date.getNowTimeStamp(), Formats.YMD_HMS)),
              Text('1993-04-28：' +
                  Date.getFormatDate(Date.getNowTimeStamp(), Formats.YMD)),
              Text('1993年04月28日：' +
                  Date.getFormatDate(
                      Date.getNowTimeStamp(), Formats.YMD_CHINESS)),
              Text('05:16:51：' +
                  Date.getFormatDate(Date.getNowTimeStamp(), Formats.HMS)),
              Text('05时16分51秒：' +
                  Date.getFormatDate(
                      Date.getNowTimeStamp(), Formats.HMS_CHINESS)),
              Text('1993年04月28日 05时16分51秒：' +
                  Date.getFormatDate(
                      Date.getNowTimeStamp(), Formats.YMD_HMS_CHINESS)),
              Text('1993年04月28日 05:16:51：' +
                  Date.getFormatDate(
                      Date.getNowTimeStamp(), Formats.YMD_CHINESS_HMS)),
            ],
          ),
        ),
      ),
    );
  }

  void showView() {
    /// 获取当前时间
    now = Date.getNow();

    /// 获取当前时间戳(13位，毫秒级)
    date1 = Date.getNowTimeStamp();

    /// 时间戳转日期
    date2 = Date.timeStampToDate(date1);

    /// 拼接成date
    date3 = Date.dentistAppointment(2019, 6, 20, 17, 30, 20);
  }
}
