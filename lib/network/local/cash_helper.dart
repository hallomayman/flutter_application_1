import 'package:flutter_application_1/shared/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putData(
      {required String key, required bool isDark}) async {
    return await sharedPreferences.setBool(key, isDark);
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);

    uId = value;
    print(uId);
    return await sharedPreferences.setString(key, value);
  }

  static Future<bool> clearData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> removeData({
    required String key,
  }) {
    return sharedPreferences.remove(key);
  }
}
