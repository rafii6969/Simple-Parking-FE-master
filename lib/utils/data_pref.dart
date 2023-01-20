import 'package:shared_preferences/shared_preferences.dart';

class DataPref {
  static setUserId(String userId) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("user_id", userId);
  }

  static Future<String?> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("user_id");
  }

  static clearData() async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove("user_id");
  }
}
