import 'locale/locale.dart';

export 'locale/locale.dart';

/// Outputs year as four digits
///
/// Example:
///     formatDate(DateTime(1989), [yyyy]);
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate(DateTime(1989), [yy]);
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate(DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(DateTime(1989, 5), [mm]);
///     // => 05
const String mm = 'mm';

/// Outputs month compactly
///
/// Example:
///     formatDate(DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(DateTime(1989, 5), [m]);
///     // => 5
const String m = 'm';

/// Outputs month as long name
///
/// Example:
///     formatDate(DateTime(1989, 2), [MM]);
///     // => february
const String MM = 'MM';

/// Outputs month as short name
///
/// Example:
///     formatDate(DateTime(1989, 2), [M]);
///     // => feb
const String M = 'M';

/// Outputs day as two digits
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [dd]);
///     // => 21
///     formatDate(DateTime(1989, 2, 5), [dd]);
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [d]);
///     // => 21
///     formatDate(DateTime(1989, 2, 5), [d]);
///     // => 5
const String d = 'd';

/// Outputs week in month
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [w]);
///     // => 4
const String w = 'w';

/// Outputs week in year as two digits
///
/// Example:
///     formatDate(DateTime(1989, 12, 31), [W]);
///     // => 53
///     formatDate(DateTime(1989, 2, 21), [W]);
///     // => 08
const String WW = 'WW';

/// Outputs week in year compactly
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [W]);
///     // => 8
const String W = 'W';

/// Outputs week day as long name
///
/// Example:
///     formatDate(DateTime(2018, 1, 14), [DD]);
///     // => sunday
const String DD = 'DD';

/// Outputs week day as long name
///
/// Example:
///     formatDate(DateTime(2018, 1, 14), [D]);
///     // => sun
const String D = 'D';

/// Outputs hour (0 - 11) as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [hh]);
///     // => 03
const String hh = 'hh';

/// Outputs hour (0 - 11) compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [h]);
///     // => 3
const String h = 'h';

/// Outputs hour (0 to 23) as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [HH]);
///     // => 15
const String HH = 'HH';

/// Outputs hour (0 to 23) compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 5), [H]);
///     // => 5
const String H = 'H';

/// Outputs minute as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40), [nn]);
///     // => 40
///     formatDate(DateTime(1989, 02, 1, 15, 4), [nn]);
///     // => 04
const String nn = 'nn';

/// Outputs minute compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 4), [n]);
///     // => 4
const String n = 'n';

/// Outputs second as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10), [ss]);
///     // => 10
///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [ss]);
///     // => 05
const String ss = 'ss';

/// Outputs second compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [s]);
///     // => 5
const String s = 's';

/// Outputs millisecond as three digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 099
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0), [SS]);
///     // => 009
const String SSS = 'SSS';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 99
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 9), [SS]);
///     // => 9
const String S = 'S';

/// Outputs microsecond as three digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [uuu]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [uuu]);
///     // => 099
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [uuu]);
///     // => 009
const String uuu = 'uuu';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [u]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [u]);
///     // => 99
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [u]);
///     // => 9
const String u = 'u';

/// Outputs if hour is AM or PM
///
/// Example:
///     print(formatDate(DateTime(1989, 02, 1, 5), [am]));
///     // => AM
///     print(formatDate(DateTime(1989, 02, 1, 15), [am]));
///     // => PM
const String am = 'am';

/// Outputs timezone as time offset
///
/// Example:
///
const String z = 'z';
const String Z = 'Z';

String formatDate(DateTime date, List<String> formats,
    {Locale locale = const EnglishLocale()}) {
  final sb = StringBuffer();


  for (String format in formats) {
    switch (format) {
      case yyyy:
        sb.write(_digits(date.year, 4));
        break;
      case yy:
        sb.write(_digits(date.year % 100, 2));
        break;
      case mm:
        sb.write(_digits(date.month, 2));
        break;
      case m:
        sb.write(date.month);
        break;
      case MM:
        sb.write(locale.monthsLong[date.month - 1]);
        break;
      case M:
        sb.write(locale.monthsShort[date.month - 1]);
        break;
      case dd:
        sb.write(_digits(date.day, 2));
        break;
      case d:
        sb.write(date.day);
        break;
      case w:
        sb.write((date.day + 7) ~/ 7);
        break;
      case W:
        sb.write((dayInYear(date) + 7) ~/ 7);
        break;
      case WW:
        sb.write(_digits((dayInYear(date) + 7) ~/ 7, 2));
        break;
      case DD:
        sb.write(locale.daysLong[date.weekday - 1]);
        break;
      case D:
        sb.write(locale.daysShort[date.weekday - 1]);
        break;
      case HH:
        sb.write(_digits(date.hour, 2));
        break;
      case H:
        sb.write(date.hour);
        break;
      case hh:
        int hour = date.hour % 12;
        if (hour == 0) hour = 12;
        sb.write(_digits(hour, 2));
        break;
      case h:
        int hour = date.hour % 12;
        if (hour == 0) hour = 12;
        sb.write(hour);
        break;
      case am:
        sb.write(date.hour < 12 ? 'AM' : 'PM');
        break;
      case nn:
        sb.write(_digits(date.minute, 2));
        break;
      case n:
        sb.write(date.minute);
        break;
      case ss:
        sb.write(_digits(date.second, 2));
        break;
      case s:
        sb.write(date.second);
        break;
      case SSS:
        sb.write(_digits(date.millisecond, 3));
        break;
      case S:
        sb.write(date.second);
        break;
      case uuu:
        sb.write(_digits(date.microsecond, 2));
        break;
      case u:
        sb.write(date.microsecond);
        break;
      case z:
        if (date.timeZoneOffset.inMinutes == 0) {
          sb.write('Z');
        } else {
          if (date.timeZoneOffset.isNegative) {
            sb.write('-');
            sb.write(_digits((-date.timeZoneOffset.inHours) % 24, 2));
            sb.write(_digits((-date.timeZoneOffset.inMinutes) % 60, 2));
          } else {
            sb.write('+');
            sb.write(_digits(date.timeZoneOffset.inHours % 24, 2));
            sb.write(_digits(date.timeZoneOffset.inMinutes % 60, 2));
          }
        }
        break;
      case Z:
        sb.write(date.timeZoneName);
        break;
      default:
        sb.write(format);
        break;
    }
  }
  return sb.toString();
}

String _digits(int value, int length) {
  String ret = '$value';
  if (ret.length < length) {
    ret = '0' * (length - ret.length) + ret;
  }
  return ret;
}

int dayInYear(DateTime date) =>
    date
        .difference(DateTime(date.year, 1, 1))
        .inDays;
