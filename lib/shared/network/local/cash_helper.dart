import 'package:shared_preferences/shared_preferences.dart';

// this class must be initialize before runApp method
class CashHelper {
  // late init sharedPreferences object
  static late SharedPreferences _preferences;

  // init method fore start the sharedPreferences object
  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

// this method for get any data type from the shared preferences object
  static dynamic getData({required String key}) {
    return _preferences.get(key);
  }

  // method for set all data type on shared preferences object
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _preferences.setString(key, value);
    if (value is int) return await _preferences.setInt(key, value);
    if (value is bool) return await _preferences.setBool(key, value);
    return await _preferences.setDouble(key, value);
  }

  // Remove any object data from shared preferences
  static Future<bool> removeData({
    required String key,
  }) async {
    return await _preferences.remove(key);
  }
}
