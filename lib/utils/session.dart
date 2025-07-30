import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Session {
  static Future<void> saveUser(Map user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user));
  }

  static Future<Map?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("user");
    return data != null ? jsonDecode(data) : null;
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }
}