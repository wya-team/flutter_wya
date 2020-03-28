import 'package:date/formats.dart';

import 'date_format.dart';

class Date {
  /// 获取当前时间
  static DateTime getNow() {
    return DateTime.now();
  }

  /// 获取当前时间戳(13位，毫秒级)
  static int getNowTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// 时间戳转日期
  static String timeStampToDate(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp).toString();
  }

  /// 拼接成date
  static DateTime dentistAppointment(int year,
      [int month, int day, int hour, int minute, int second]) {
    return new DateTime(year, month, day, hour, minute, second);
  }

  /// 时间比较 -- 在之前
  static bool isBefore(DateTime dateTime) {
    return DateTime.now().isBefore(dateTime);
  }

  /// 时间比较 -- 在之后
  static bool isAfter(DateTime dateTime) {
    return DateTime.now().isAfter(dateTime);
  }

  /// 时间比较 -- 相同
  static bool isAtSameMomentAs(DateTime dateTime) {
    return DateTime.now().isAtSameMomentAs(dateTime);
  }

  /// 时间增加 dateBase + duration
  static DateTime fiftyDaysFromNow(DateTime dateBase, Duration duration) {
    return dateBase.add(duration);
  }

  /// 时间减少 dateBase - duration
  static DateTime fiftyDaysAgo(DateTime dateBase, Duration duration) {
    return dateBase.subtract(duration);
  }

  /// 比较两个时间 差 小时数
  static Duration compare(DateTime before, DateTime after) {
    return before.difference(after);
  }

  /// 获取年
  static String getYear() {
    return DateTime.now().year.toString();
  }

  /// 获取月
  static String getMonth() {
    return DateTime.now().month.toString();
  }

  /// 获取日
  static String getDay() {
    return DateTime.now().day.toString();
  }

  /// 获取时
  static String getHour() {
    return DateTime.now().hour.toString();
  }

  /// 获取分
  static String getMinute() {
    return DateTime.now().minute.toString();
  }

  /// 获取秒
  static String getSecond() {
    return DateTime.now().second.toString();
  }

  /// 获取星期几
  static String getWeekDay() {
    return DateTime.now().weekday.toString();
  }

  ///格式化时间戳
  ///TimeStamp:毫秒值
  ///format:[yyyy, '-', mm, '-', dd],[yyyy, '年', mm, '月', dd, '日],
  ///结果： 2019?08?04  02?08?02
  static String getFormatDate(int timeStamp, [List<String> formats]) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
    if (formats == null) {
      formats = Formats.YMD_HMS;
    }
    String formatResult = formatDate(dateTime, formats);
    return formatResult;
  }
}
