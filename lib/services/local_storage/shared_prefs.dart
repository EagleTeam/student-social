import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

extension CalendarViewSupport on String {
  CalendarView toCalendarView() {
    if (this == CalendarView.month.toString()) {
      return CalendarView.month;
    } else {
      return CalendarView.schedule;
    }
  }
}

class SharedPrefs {
  SharedPrefs._();

  static SharedPrefs _instance;

  static SharedPrefs get instance {
    _instance ??= SharedPrefs._();
    return _instance;
  }

  static const String _currentMSV = 'current_msv';
  static const String _currentCalendarView = 'calendar_view';

  Future<bool> setCurrentMSV(String msv) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_currentMSV, msv);
  }

  Future<String> getCurrentMSV() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentMSV);
  }

  Future<bool> setCalendarView(CalendarView calendarView) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_currentCalendarView, calendarView.toString());
  }

  Future<CalendarView> getCalendarView() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_currentCalendarView);
    return value.toCalendarView();
  }
}
