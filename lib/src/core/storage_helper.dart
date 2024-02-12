import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setValue(String key, dynamic value) async {
    if (_prefs == null) {
      await initialize();
    }
    if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    }
  }

  static dynamic getValue(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs?.get(key);
  }
}

class StorageKeys {
  static const String token = 'token';
  static const String userId = 'userId';
  static const String refreshToken = 'refreshToken';
  static const String identifier = 'identifier';
}
