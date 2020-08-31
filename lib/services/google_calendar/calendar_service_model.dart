import 'package:google_sign_in/google_sign_in.dart';

import '../../helpers/logging.dart';
import '../../models/entities/calendar.dart';
import '../../models/entities/event_student_social.dart';
import '../../models/entities/login_result.dart';
import '../../models/entities/schedule.dart';
import '../google_signin/google_http_client.dart';
import '../google_signin/google_sign_in.dart';
import 'calendar_service_communicate.dart';

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