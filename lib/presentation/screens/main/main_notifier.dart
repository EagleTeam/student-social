import 'dart:async';

import 'package:action_mixin/action_mixin.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../events/alert.dart';
import '../../../events/alert_update_schedule.dart';
import '../../../helpers/logging.dart';
import '../../../helpers/notification.dart';
import '../../../main.dart';
import '../../../models/entities/event_student_social.dart';
import '../../../models/entities/login_result.dart';
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';
import '../../../services/google_calendar/calendar_service_communicate.dart';
import '../../../services/google_calendar/calendar_service_model.dart';
import '../../../services/local_storage/database/database.dart';
import '../../../services/local_storage/database/repository/profile_repository.dart';
import '../../../services/local_storage/database/repository/schedule_repository.dart';
import '../../../services/local_storage/shared_prefs.dart';
import 'main_model.dart';

final currentMSVProvider = StateProvider<String>((ref) {
  return 'guest';
});

final mainProvider = ChangeNotifierProvider<MainNotifier>((ref) {
  return MainNotifier(ref.watch(databaseProvider), ref.read);
});

class MainNotifier with ChangeNotifier, ActionMixin {
  MainNotifier(MyDatabase database, this.read) {
    _profileRepository = ProfileRepository(database);
    _scheduleRepository = ScheduleRepository(database);
    _mainModel = MainModel();
    _notification = Notification();
    _sharedPrefs = SharedPrefs();
    _calendarServiceModel = CalendarServiceModel();
    _initLoad();
  }

  Reader read;

  MainModel _mainModel;
  Notification _notification;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;
  CalendarServiceModel _calendarServiceModel;
  final StreamController _streamResultUpload = StreamController();

  SharedPrefs _sharedPrefs;

  Future<void> _initLoad() async {
    await insertProfileGuest();
    await loadCurrentMSV();
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

  String get getTitle => _mainModel.title;

  String get getName {
    if (read(currentMSVProvider).state == 'guest') {
      return 'Khách';
    }
    return _mainModel?.profile?.HoTen ?? 'Họ Tên';
  }

  String get getClass => _mainModel?.profile?.Lop ?? '';

  String get getToken => _mainModel?.profile?.Token ?? '';

  Map<String, List<Schedule>> get getEntriesOfDay => _mainModel.entriesOfDay;

  String get getMSV => read(currentMSVProvider).state;

  bool get isGuest =>
      getMSV == null ||
      getMSV == 'guest' ||
      getName == null ||
      getName == 'Họ Tên';

  String get getAvatarName {
    final String name = getName;
    final List<String> splitName = name.split(' ');
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
    return await _calendarServiceModel
        .getEventStudentSocials(_mainModel.schedules);
  }

  CalendarServiceCommunicate get calendarServiceCommunicate {
    return _calendarServiceModel.calendarServiceCommunicate;
  }

  Future<int> insertProfileGuest() async {
    return await _profileRepository.insertOnlyUser(Profile.guest());
  }

  Future<void> loadCurrentMSV() async {
    final String value = await _sharedPrefs.getCurrentMSV();

    if (value == null || value.isEmpty) {
      return;
    }
    if (value.isNotEmpty) {
      read(currentMSVProvider).state = value;
    }
    loadProfile();
    loadSchedules();
    loadAllProfile();
  }

  Future<void> loadProfile() async {
    final Profile profile = await _profileRepository.getUserByMaSV(getMSV);
    _mainModel.profile = profile;
    notifyListeners();
  }

  Future<void> loadAllProfile() async {
    final List<Profile> profiles = await _profileRepository.getAllUsers();
    _mainModel.allProfile = profiles;
    notifyListeners();
  }

  Future<void> loadSchedules() async {
    final List<Schedule> schedule =
        await _scheduleRepository.getListSchedules(getMSV);
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

    final int len = schedules.length;
    Schedule schedule;
    for (int i = 0; i < len; i++) {
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
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      callback(EventAlert(message: 'Không có kết nối mạng :('));
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      callback(const EventAlertUpdateSchedule());
    }
  }

  Future<void> launchURL() async {
    const String url = 'https://m.me/hoangthang1412';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> logOut() async {
    //kiểm tra xem còn profile nào không, nếu còn thì mặc định nó lấy luôn thằng profile đầu tiên để sử dụng tiếp
    // nếu không còn thằng profile nào thì set currentmsv = '',
    //xoá hết lịch,điểm,profile của thằng msv hiện tại

    try {
      List<Profile> profiles = await _profileRepository.getAllUsers();

      //lấy ra toàn bộ user có trong máy
      profiles.removeWhere((profile) =>
          profile.MaSinhVien == getMSV); // xoá đi user hiện tại muốn đăng xuất
      //kiểm tra nếu list vẫn còn user thì gán vào shared msv của thằng đầu tiên luôn
      //nếu không còn thằng nào thì gán vào shared '' (empty)
      if (profiles.isNotEmpty) {
        await _sharedPrefs.setCurrentMSV(profiles[0].MaSinhVien);
      } else {
        //không còn thằng nào :((
        await _sharedPrefs.setCurrentMSV('');
      }
      //Xoá profile
      await _profileRepository.deleteUserByMSV(getMSV);
      //Xoá điểm
      //TODO: Xoa diem
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeMarkByMSV,
//          <String, String>{'msv': _mainModel.msv});
      //Xoá lịch
      await _scheduleRepository.deleteScheduleByMSV(getMSV);
      //reset data
      _mainModel.resetData();
      loadCurrentMSV();
      callback(EventAlert(message: 'Đăng xuất thành công'));
      notifyListeners();
    } catch (e) {
      logs('error is:$e');
      _mainModel.resetData();
      loadCurrentMSV();
      callback(EventAlert(message: 'Đăng xuất bị lỗi: $e'));
      notifyListeners();
    }
  }

  Future<void> switchToProfile(Profile profile) async {
    // đặt lại currentmsv trong shared
    await _sharedPrefs.setCurrentMSV(profile.MaSinhVien);
//    reset data
    _mainModel.resetData();
    notifyListeners();
    loadCurrentMSV();
  }

  getRandomColor() {
//    return _mainModel.colors[Random().nextInt(_mainModel.colors.length)];
  }

  void calendarPageChanged(int index) {
//    if (index != 12) {
    //nếu nhảy sang page khác page mặc định thì hiện lên
//      if (_mainModel.hideButtonCurrent) {
//        inputAction.add({'type': MainAction.forward});
//        _mainModel.hideButtonCurrent = false;
//      }
//    } else if (_isCurrentDay(
//        _mainModel.clickDay, _mainModel.clickMonth, _mainModel.clickYear)) {
//      nếu là page mặc định và ngày đang chọn cũng là currentday thì ẩn nó đi
//      if (!_mainModel.hideButtonCurrent) {
//        inputAction.add({'type': MainAction.reverse});
//        _mainModel.hideButtonCurrent = true;
//      }
//    }
  }
}
