import 'package:shared_preferences/shared_preferences.dart';

void localSave<T>(String key, T value) async {
  var prefs = await SharedPreferences.getInstance();
  if (value is String) {
    await prefs.setString(key, value);
  }
  if (value is List<String>) {
    await prefs.setStringList(key, value);
  }
  if (value is bool) {
    await prefs.setBool(key, value);
  }

  if (value is int) {
    await prefs.setInt(key, value);
  }

  if (value is double) {
    await prefs.setDouble(key, value);
  }
}

Future<dynamic> localGet(String key) async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.get(key);
}