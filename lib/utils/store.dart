import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<bool> setSet(String key, Set<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, value.toList());
  }

  static Future<String?>? getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<Set<String>> getSet(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final r = prefs.getStringList(key);
    if (r == null) {
      return <String>{};
    }
    return r.toSet();
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
