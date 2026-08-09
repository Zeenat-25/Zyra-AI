import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class PreferencesService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await instance;
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await instance;
    return prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await instance;
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await instance;
    return prefs.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await instance;
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await instance;
    return prefs.getInt(key);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await instance;
    await prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await instance;
    return prefs.getStringList(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await instance;
    await prefs.remove(key);
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await instance;
    return prefs.containsKey(key);
  }

  static Future<void> clear() async {
    final prefs = await instance;
    await prefs.clear();
  }
}
