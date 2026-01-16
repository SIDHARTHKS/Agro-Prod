import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  late SharedPreferences _prefs;

  // Singleton instance
  static final SharedPreferenceHelper _instance =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _instance;
  }

  SharedPreferenceHelper._internal();

  // Initialize shared preferences
  Future<SharedPreferenceHelper> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _instance;
  }

  // Set int value
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  // Get int value
  int getInt(String key, {int defaultValue = -1}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // Set double value
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  // Get double value
  double getDouble(String key, {double defaultValue = -1}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // Set bool value
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  // Get bool value
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // Set String value
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // Get String value
  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // Set List<String> value
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  // Get List<String> value
  List<String> getStringList(String key, {List<String>? defaultValue}) {
    return _prefs.getStringList(key) ?? defaultValue!;
  }

  // Remove a key-value pair
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return _prefs.clear();
  }
}
