// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:action_mixin/action_mixin.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import '../../../events/alert.dart';
import '../../../events/alert_update_schedule.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login_result.dart';
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';
import '../../../services/google_calendar/calendar_service_communicate.dart';
import '../../../services/google_calendar/calendar_service_model.dart';
import '../../../services/google_calendar/event_calendar_entry.dart';
import '../../../services/local_storage/database/repository/profile_repository.dart';
import '../../../services/local_storage/database/repository/schedule_repository.dart';
import '../../../services/local_storage/shared_prefs.dart';
import '../../../services/notification/notification.dart';
import 'main_model.dart';

/// provider current msv
final currentMSVProvider = StateProvider<String>((ref) {
  return 'guest';
});

/// provider mainNotifier
final mainProvider = ChangeNotifierProvider<MainNotifier>((ref) {
  return MainNotifier(ref);
});

// ignore: public_member_api_docs
class MainNotifier with ChangeNotifier, ActionMixin {
  /// handle in main screen
  MainNotifier(this.ref) {
    _mainModel = MainModel();
    _notification = NotificationConfig();
    _calendarServiceModel = CalendarServiceModel();
    _initLoad();
  }

  ProviderReference ref;

  MainModel _mainModel;
  NotificationConfig _notification;
  CalendarServiceModel _calendarServiceModel;
  final StreamController _streamResultUpload = StreamController();

  Future<void> _initLoad() async {
    await insertProfileGuest();
    await loadCurrentMSV();
    await loadProfile();
    await loadSchedules();
    await loadAllProfile();
  }

  List<Schedule> get getSchedules => _mainModel.schedules;

  List<Profile> get getAllProfile => _mainModel.allProfile;

  @override
  void dispose() {
    _streamResultUpload.close();
    super.dispose();
  }

  Stream get getStreamUpload => _streamResultUpload.stream;

  Sink get inputStreamUpload => _streamResultUpload.sink;

  String get getName {
    if (getMSV == 'guest') {
      return 'Khách';
    }
    return _mainModel?.profile?.HoTen ?? 'Họ Tên';
  }

  String get getClass => _mainModel?.profile?.Lop ?? '';

  String get getToken => _mainModel?.profile?.Token ?? '';

  Map<String, List<Schedule>> get getEntriesOfDay => _mainModel.entriesOfDay;

  String get getMSV => ref.read(currentMSVProvider).state;

  bool get isGuest =>
      getMSV == null ||
      getMSV == 'guest' ||
      getName == null ||
      getName == 'Họ Tên';

  /// return charAt(0) of name
  String get getAvatarName {
    final splitName = getName.split(' ');
    return splitName.last[0];
  }

  Future<LoginResult> googleLogin() async {
    return _calendarServiceModel.loginAction();
  }

  Future<GoogleSignInAccount> googleLogout() async {
    return _calendarServiceModel.googleLogout();
  }

  Future<List<EventStudentSocial>> getEventStudentSocials() async {
    logs('upload schedules');
    return _calendarServiceModel.getEventStudentSocials(_mainModel.schedules);
  }

  CalendarServiceCommunicate get calendarServiceCommunicate {
    return _calendarServiceModel.calendarServiceCommunicate;
  }

  Future<int> insertProfileGuest() async {
    return await ProfileRepository.instance.insertOnlyUser(Profile.guest());
  }

  Future<void> loadCurrentMSV() async {
    final value = await SharedPrefs.instance.getCurrentMSV();

    if (value == null || value.isEmpty) {
      return;
    }
    if (value.isNotEmpty) {
      ref.read(currentMSVProvider).state = value;
    }
  }

  Future<void> loadProfile() async {
    final profile = await ProfileRepository.instance.getUserByMSV(getMSV);
    _mainModel.profile = profile;
    notifyListeners();
  }

  Future<void> loadAllProfile() async {
    final profiles = await ProfileRepository.instance.getAllUsers();
    _mainModel.allProfile = profiles;
    notifyListeners();
  }

  Future<void> loadSchedules() async {
    final schedule = await ScheduleRepository.instance.getListSchedules(getMSV);
    _mainModel.schedules = schedule;
    notifyListeners();
    logs('schedule is ${schedule.length}');
    logs('msv is ${getMSV}');
    _initEntries(schedule);
  }

  void _initEntries(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return;
    } //neu gia tri ban dau rong thi se khong can initentries nua , return luon

    //clear entries map truoc khi init lan thu 2 tro di
    if (_mainModel.entriesOfDayNotEmpty) {
      _mainModel.clearEntriesOfDay();
    }
    _initEntriesBySchedule(schedules);
  }

  void _initEntriesBySchedule(List<Schedule> schedules) {
    //khoi tao entriesOfDay, neu khoi tao roi thi dung tiep
    _mainModel.initEntriesOfDayIfNeed();

    final len = schedules.length;
    Schedule schedule;
    for (var i = 0; i < len; i++) {
      schedule = schedules[i];
      _mainModel.initEntriesIfNeed(schedule.getNgay);
      _mainModel.addScheduleToEntriesOfDay(schedule);
    }

    //sau khi đã lấy được toàn bộ lịch rồi thì sẽ tiến hành đặt thông báo lịch hàng ngày.
    _notification.initSchedulesNotification(_mainModel.entriesOfDay, getMSV);
  }

  void updateSchedule() {
    _checkInternetConnectivity();
  }

  Future<void> _checkInternetConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      callback(const EventAlert(message: 'Không có kết nối mạng :('));
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      callback(const EventAlertUpdateSchedule());
    }
  }

  /// launch to messenger to ib with admin EagleTeam
  Future<void> launchURL() async {
    const url = 'https://m.me/hoangthang1412';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> logOut() async {
    //kiểm tra xem còn profile nào không, nếu còn thì mặc định nó lấy luôn thằng profile đầu tiên để sử dụng tiếp
    // nếu không còn thằng profile nào thì set currentmsv = '',
    //xoá hết lịch,điểm,profile của thằng msv hiện tại

    try {
      final profiles = await ProfileRepository.instance.getAllUsers();

      //lấy ra toàn bộ user có trong máy
      profiles.removeWhere((profile) =>
          profile.MaSinhVien == getMSV); // xoá đi user hiện tại muốn đăng xuất
      //kiểm tra nếu list vẫn còn user thì gán vào shared msv của thằng đầu tiên luôn
      //nếu không còn thằng nào thì gán vào shared '' (empty)
      if (profiles.isNotEmpty) {
        await SharedPrefs.instance.setCurrentMSV(profiles[0].MaSinhVien);
      } else {
        //không còn thằng nào :((
        await SharedPrefs.instance.setCurrentMSV('');
      }
      //Xoá profile
      await ProfileRepository.instance.deleteUserByMSV(getMSV);
      //Xoá điểm
      //TODO: Xoa diem
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeMarkByMSV,
//          <String, String>{'msv': _mainModel.msv});
      //Xoá lịch
      await ScheduleRepository.instance.deleteScheduleByMSV(getMSV);
      //reset data
      _mainModel.resetData();
      await loadCurrentMSV();
      callback(const EventAlert(message: 'Đăng xuất thành công'));
      notifyListeners();
    } catch (e) {
      logs('error is:$e');
      _mainModel.resetData();
      await loadCurrentMSV();
      callback(EventAlert(message: 'Đăng xuất bị lỗi: $e'));
      notifyListeners();
    }
  }

  /// switch to another profile to see the information of that
  Future<void> switchToProfile(Profile profile) async {
    // đặt lại currentmsv trong shared
    await SharedPrefs.instance.setCurrentMSV(profile.MaSinhVien);
//    reset data
    _mainModel.resetData();
    notifyListeners();
    await loadCurrentMSV();
  }
}
