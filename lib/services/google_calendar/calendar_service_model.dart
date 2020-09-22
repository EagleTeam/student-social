// Package imports:
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import '../../helpers/logging.dart';
import '../../models/entities/login_result.dart';
import '../../models/entities/schedule.dart';
import '../google_signin/google_http_client.dart';
import '../google_signin/google_sign_in.dart';
import 'calendar_entry.dart';
import 'calendar_service_communicate.dart';
import 'event_calendar_entry.dart';

class CalendarServiceModel {
  GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();
  CalendarServiceCommunicate calendarServiceCommunicate;
  LoginResult loginResult;

  Future<LoginResult> loginAction() async {
    final result = await googleSignInHelper.signInWithGoogle();
    loginResult = result;
    return result;
  }

  Future<GoogleSignInAccount> googleLogout() async {
    return await googleSignInHelper.signOutGoogle();
  }

  Future<List<EventStudentSocial>> getEventStudentSocials(
      List<Schedule> schedules) async {
    final List<EventStudentSocial> events =
        schedules.map((e) => EventStudentSocial(e)).toList();

    logs('events is $events');
    calendarServiceCommunicate =
        CalendarServiceCommunicate(GoogleHttpClient(loginResult.headers));
    await calendarServiceCommunicate.deleteOldCalendars();
    final calendar = await calendarServiceCommunicate.insertNewCalendars();
    logs(calendar.summary);
    logs(CalendarStudentSocial.summary);
    if (calendar.summary != CalendarStudentSocial.summary) {
      return [];
    }
    logs('addEvents');
    return events;
  }
}
