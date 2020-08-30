import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studentsocial/models/entities/event.dart';
import 'package:studentsocial/models/entities/event_student_social.dart';
import 'package:studentsocial/models/entities/login_result.dart';
import 'package:studentsocial/services/google_calendar/calendar_service_communicate.dart';
import 'package:studentsocial/services/google_calendar/calendar_service_model.dart';
import 'package:studentsocial/services/local_storage/database/database.dart';
import 'package:studentsocial/services/local_storage/database/repository/profile_repository.dart';
import 'package:studentsocial/services/local_storage/database/repository/schedule_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/logging.dart';
import '../../../helpers/notification.dart';
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';
import '../../../services/local_storage/shared_prefs.dart';
import 'main_model.dart';

class MainNotifier with ChangeNotifier {
  MainNotifier(MyDatabase database) {
    _profileRepository = ProfileRepository(database);
    _scheduleRepository = ScheduleRepository(database);
    _mainModel = MainModel();
    _notification = Notification();
    _sharedPrefs = SharedPrefs();
    _calendarServiceModel = CalendarServiceModel();
    _initLoad();
  }

  MainModel _mainModel;
  final StreamController<Events> _streamController = StreamController<Events>();
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

  DateTime get getClickedDay => _mainModel.clickDate;

  @override
  void dispose() {
    _streamController.close();
    _streamResultUpload.close();
    super.dispose();
  }

  Stream get getStreamUpload => _streamResultUpload.stream;

  Sink get inputStreamUpload => _streamResultUpload.sink;

  Stream<Events> get getStreamAction => _streamController.stream;

  Sink<Events> get inputAction => _streamController.sink;

  String get getTitle => _mainModel.title;

  double get getWidth => _mainModel.width;

  double get getItemWidth => _mainModel.itemWidth;

  double get getItemHeight => _mainModel.itemHeight;

  double get getDrawerHeaderHeight => _mainModel.drawerHeaderHeight;

  String get getName {
    if (_mainModel.msv == 'guest') {
      return 'Khách';
    }
    return _mainModel?.profile?.HoTen ?? 'Họ Tên';
  }

  String get getClass => _mainModel?.profile?.Lop ?? '';

  String get getToken => _mainModel?.profile?.Token ?? '';

  Map<String, List<Schedule>> get getEntriesOfDay => _mainModel.entriesOfDay;

  double get getTableHeight => _mainModel.tableHeight;

  int get getClickMonth => _mainModel.clickDate.month;

  DateTime get getDateCurrentClick => _mainModel.clickDate;

  String get getKeyOfCurrentEntries => _mainModel.keyOfCurrentEntries;

  int get getCurrentDay => _mainModel.currentDate.day;

  int get getCurrentMonth => _mainModel.currentDate.month;

  int get getCurrentYear => _mainModel.currentDate.year;

  int get getClickDay => _mainModel.clickDate.day;

  String get getMSV => _mainModel.msv;

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
      _mainModel.msv = value;
    }
    loadProfile();
    loadSchedules();
    loadAllProfile();
  }

  Future<void> loadProfile() async {
    final Profile profile =
        await _profileRepository.getUserByMaSV(_mainModel.msv);
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
        await _scheduleRepository.getListSchedules(_mainModel.msv);
    _mainModel.schedules = schedule;
    notifyListeners();
    logs('schedule is ${schedule.length}');
    logs('msv is ${_mainModel.msv}');
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
    _notification.initSchedulesNotification(
        _mainModel.entriesOfDay, _mainModel.msv);
  }

  void updateSchedule() {
    _checkInternetConnectivity();
  }

  Future<void> _checkInternetConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      inputAction.add(
          const Events(EventType.alertMessage, 'Không có kết nối mạng :('));
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      inputAction.add(const Events(EventType.alertUpdateSchedule));
    }
  }

  void initSize(Size size) {
    _mainModel.initSize(size);
  }

  Future<void> launchURL() async {
    const String url = 'https://m.me/hoangthang1412';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getStringForKey(int i) {
    if (i < 10) {
      return '0$i';
    }
    return i.toString();
  }

  void clickedOnCurrentDay() {
    logs(
        'clickedOnDay ${getStringForKey(getCurrentDay)},${getStringForKey(getCurrentMonth)},$getCurrentYear from calendar_widget');
    _mainModel.clickDate = _mainModel.currentDate;
    notifyListeners();
  }

  void clickedOnDay(int day, int month, int year) {
    logs(
        'clickedOnDay ${getStringForKey(day)},${getStringForKey(month)},$year from calendar_widget');
    _mainModel.clickDate = DateTime(year, month, day);
    notifyListeners();
  }

  bool _isCurrentDay(int d, int m, int y) {
    return d == getCurrentDay && m == getCurrentMonth && y == getCurrentYear;
  }

  void setClickDay(int clickDay) {
    _mainModel.clickDate = DateTime(
        _mainModel.clickDate.year, _mainModel.clickDate.month, clickDay);
  }

  void setClickMonth(int month) {
    _mainModel.clickDate =
        DateTime(_mainModel.clickDate.year, month, _mainModel.clickDate.day);
  }

  Future<void> logOut() async {
    //kiểm tra xem còn profile nào không, nếu còn thì mặc định nó lấy luôn thằng profile đầu tiên để sử dụng tiếp
    // nếu không còn thằng profile nào thì set currentmsv = '',
    //xoá hết lịch,điểm,profile của thằng msv hiện tại

    try {
      List<Profile> profiles = await _profileRepository.getAllUsers();

      //lấy ra toàn bộ user có trong máy
      profiles.removeWhere((profile) =>
          profile.MaSinhVien ==
          _mainModel.msv); // xoá đi user hiện tại muốn đăng xuất
      //kiểm tra nếu list vẫn còn user thì gán vào shared msv của thằng đầu tiên luôn
      //nếu không còn thằng nào thì gán vào shared '' (empty)
      if (profiles.isNotEmpty) {
        await _sharedPrefs.setCurrentMSV(profiles[0].MaSinhVien);
      } else {
        //không còn thằng nào :((
        await _sharedPrefs.setCurrentMSV('');
      }
      //Xoá profile
      await _profileRepository.deleteUserByMSV(_mainModel.msv);
      //Xoá điểm
      //TODO: Xoa diem
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeMarkByMSV,
//          <String, String>{'msv': _mainModel.msv});
      //Xoá lịch
      await _scheduleRepository.deleteScheduleByMSV(_mainModel.msv);
      //reset data
      _mainModel.resetData();
      loadCurrentMSV();
      inputAction
          .add(const Events(EventType.alertMessage, 'Đăng xuất thành công'));
      notifyListeners();
    } catch (e) {
      logs('error is:$e');
      _mainModel.resetData();
      loadCurrentMSV();
      inputAction.add(Events(EventType.alertMessage, 'Đăng xuất bị lỗi: $e'));
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
