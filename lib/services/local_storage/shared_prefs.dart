import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPrefs _instance;

  static SharedPrefs get instance {
    _instance ??= SharedPrefs();
    return _instance;
  }

  static const String _currentMSV = 'current_msv';

  Future<bool> setCurrentMSV(String msv) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_currentMSV, msv);
  }

  Future<String> getCurrentMSV() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentMSV);
  }
}
