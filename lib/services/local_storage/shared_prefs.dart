import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String currentMSV = 'current_msv';
  Future<bool> setCurrentMSV(String msv) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(currentMSV, msv);
  }

  Future<String> getCurrentMSV() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentMSV);
  }
}
