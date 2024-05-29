import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  /// Initializes the SharedPreferences instance by calling the `getInstance()` method
  /// from the SharedPreferences class.
  ///
  /// This function is asynchronous and returns a `Future<void>`.
  ///
  /// No parameters.
  ///
  /// No return value.
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Sets the value for the given [key] in the SharedPreferences.
  ///
  /// The [key] parameter is the key to identify the value in the SharedPreferences.
  /// The [value] parameter is the value to be stored. It can be of type [int], [double],
  /// [bool], [String], or [List<String>].
  ///
  /// This function first checks if the SharedPreferences instance is null. If it is,
  /// it calls the `initialize()` function to initialize the SharedPreferences.
  ///
  /// Then, it checks the type of the [value] parameter and uses the appropriate
  /// method from the SharedPreferences instance to set the value.
  ///
  /// If the [value] is of type [int], it calls `setInt()` method with the [key] and
  /// [value] parameters.
  /// If the [value] is of type [double], it calls `setDouble()` method with the
  /// [key] and [value] parameters.
  /// If the [value] is of type [bool], it calls `setBool()` method with the [key]
  /// and [value] parameters.
  /// If the [value] is of type [String], it calls `setString()` method with the
  /// [key] and [value] parameters.
  /// If the [value] is of type [List<String>], it calls `setStringList()` method
  /// with the [key] and [value] parameters.
  ///
  /// This function is asynchronous and returns a `Future<void>`.
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

  /// Retrieves the value associated with the given [key] from the SharedPreferences.
  ///
  /// The [key] parameter is the key used to identify the value in the SharedPreferences.
  ///
  /// Returns:
  /// - The value associated with the given [key], or `null` if the value does not exist or if SharedPreferences has not been initialized.
  ///
  /// Throws:
  /// - An [Exception] if SharedPreferences has not been initialized.
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
  static const String orderId = 'orderId';
  static const String xApiKey = 'xApiKey';
  static const String myAddressesList = 'myAddressesList';
  static const String isSandBox = 'isSandBox';
}
