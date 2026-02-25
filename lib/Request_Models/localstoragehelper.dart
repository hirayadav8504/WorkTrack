import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<SharedPreferences> _prefs() async =>
      await SharedPreferences.getInstance();

  static Future setString(String key, String value) async {
    final pref = await _prefs();
    pref.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final pref = await _prefs();
    return pref.getString(key);
  }

  static Future setDouble(String key, double value) async {
    final pref = await _prefs();
    pref.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final pref = await _prefs();
    return pref.getDouble(key);
  }

  //  ADD THESE
  static Future setBool(String key, bool value) async {
    final pref = await _prefs();
    pref.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final pref = await _prefs();
    return pref.getBool(key);
  }
}
