import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/models/entities/semester.dart';
import 'package:studentsocial/services/http/rest_client.dart';
import 'package:studentsocial/services/local_storage/database/database.dart';
import 'package:studentsocial/services/local_storage/database/repository/profile_repository.dart';
import 'package:studentsocial/services/local_storage/database/repository/schedule_repository.dart';

import '../../../helpers/logging.dart';
import '../../../models/entities/login.dart';
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';
import '../../../services/local_storage/shared_prefs.dart';
import 'login_state.dart';

enum LoginAction {
  alert_with_message,
  loading,
  alert_chon_kyhoc,
  pop,
  save_success
}

class LoginNotifier with ChangeNotifier {
  LoginNotifier(MyDatabase database) {
    _sharedPrefs = SharedPrefs();
    _profileRepository = ProfileRepository(database);
    _scheduleRepository = ScheduleRepository(database);
    _loginModel = LoginState();
    _streamController = StreamController();
  }

  LoginState _loginModel;
  StreamController _streamController;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;
  final RestClient _client = RestClient.create();

  SharedPrefs _sharedPrefs;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  bool dataIsInvalid(String email, String password) =>
      email.trim().isEmpty || password.trim().isEmpty;

  Sink _inputAction() {
    return _streamController.sink;
  }

  Stream getActionStream() {
    return _streamController.stream;
  }

  void _pop() {
    _inputAction().add({'type': LoginAction.pop});
  }

  void _loading(String msg) {
    _inputAction().add({'type': LoginAction.loading, 'data': msg});
  }

  Future<void> submit(String email, String password) async {
    final bool isOnline = await _checkInternetConnectivity();
    if (!isOnline) {
      return;
    }
    if (dataIsInvalid(email, password)) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Bạn không được để trống Mã sinh viên hoặc mật khẩu'
      });
      return;
    }
    if (await isExists(email.toUpperCase())) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Mã sinh viên này đã được thêm rồi'
      });
      return;
    }
    _loading('Đang đăng nhập...');
    _actionLogin(email.toUpperCase(), password);
  }

  Future<bool> isExists(String email) async {
    final Profile allProfile = await _profileRepository.getUserByMaSV(email);
    return allProfile != null;
  }

  Future<bool> _checkInternetConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Không có kết nối mạng :('
      });
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<void> _actionLogin(String msv, String password) async {
    final LoginResult result = await _client.login(msv, password);
    _loginModel.msv = msv;
    if (result.isSuccess()) {
      _loginModel.profile = (result as LoginSuccess).message.profile;
      _loginModel.token = (result as LoginSuccess).message.Token;
      _pop();
      _loading('Đang tải kỳ học');
      _getSemester(_loginModel.token);
    } else {
      _pop();
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Mã sinh viên hoặc mật khẩu đăng nhập sai !'
      });
    }
  }

  Future<void> _getSemester(String token) async {
    logs('token is $token');
    final SemesterResult semesterResult = await _client.getSemester(token);
    logs('semesterResult is ${semesterResult.toJson()}');
    _pop();
    _inputAction()
        .add({'type': LoginAction.alert_chon_kyhoc, 'data': semesterResult});
  }

  void semesterClicked(String data) {
    logs('data is $data');
    _pop();
    _loginModel.semester = data;
    _loadData(data);
  }

  Future<void> _loadData(String semester) async {
    _loading('Đang lấy lịch học');
    _loginModel.lichHoc = await _client.getLichHoc(_loginModel.token, semester);
    _pop();
    _loading('Đang lấy lịch thi');
    _loginModel.lichThi = await _client.getLichThi(_loginModel.token, semester);
    _pop();
    _saveInfo();
  }

  Future<void> _saveInfo() async {
    //TODO: add later
    _loading('Đang lưu thông tin người dùng');
    final int resProfile =
        await _profileRepository.insertOnlyUser(_loginModel.profile);
    _pop();
    logs('saveProfileToDB: $resProfile');
    final bool resCurrentMSV =
        await _sharedPrefs.setCurrentMSV(_loginModel.msv);
    logs('saveCurrentMSV:$resCurrentMSV');
    _loading('Đang lưu lịch cá nhân');
    await saveMarkToDB();
    if (_loginModel.lichHoc.isSuccess()) {
      (_loginModel.lichHoc as ScheduleSuccess).message.addMSV(_loginModel.msv);
      await _scheduleRepository.insertListSchedules(
          (_loginModel.lichHoc as ScheduleSuccess).message.Entries);
    }
    if (_loginModel.lichThi.isSuccess()) {
      (_loginModel.lichThi as ScheduleSuccess).message.addMSV(_loginModel.msv);
      await _scheduleRepository.insertListSchedules(
          (_loginModel.lichThi as ScheduleSuccess).message.Entries);
    }
    _pop();
    _inputAction().add({'type': LoginAction.save_success});
    await Future.delayed(Duration(milliseconds: 800));
    _pop();
  }

  Future<void> saveMarkToDB() async {
    //TODO: save mark to db
//    var res = await PlatformChannel().saveMarkToDB(
//        mark, json.encode(subjectsName), json.encode(subjectsSoTinChi), msv);
//    print('saveMarkToDB: $res');
  }
}
