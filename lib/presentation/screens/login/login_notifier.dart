import 'dart:async';

import 'package:action_mixin/action_mixin.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/alert.dart';
import '../../../events/alert_chon_kyhoc.dart';
import '../../../events/loading_message.dart';
import '../../../events/pop.dart';
import '../../../events/save_success.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login.dart';
import '../../../models/entities/schedule.dart';
import '../../../services/http/rest_client.dart';
import '../../../services/local_storage/database/repository/profile_repository.dart';
import '../../../services/local_storage/database/repository/schedule_repository.dart';
import '../../../services/local_storage/shared_prefs.dart';
import 'login_state.dart';

/// Provider login ChangeNotifier
final loginProvider = ChangeNotifierProvider<LoginNotifier>((ref) {
  return LoginNotifier(ref);
});

/// Login ChangeNotifier
class LoginNotifier with ChangeNotifier, ActionMixin {
  /// Login ChangeNotifier
  LoginNotifier(ProviderReference ref) {
    _profileRepository = ref.watch(profileRepositoryProvider);
    _scheduleRepository = ref.watch(scheduleRepositoryProvider);
    _loginModel = LoginState();
  }

  LoginState _loginModel;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;

  bool _dataIsInvalid(String email, String password) =>
      email.trim().isEmpty || password.trim().isEmpty;

  /// handle request submit email & password from UI
  /// and do request login or show dialog
  Future<void> submit(String email, String password) async {
    final isOnline = await _checkInternetConnectivity();
    if (!isOnline) {
      return;
    }
    if (_dataIsInvalid(email, password)) {
      callback(const EventAlert(
          message: 'Bạn không được để trống Mã sinh viên hoặc mật khẩu'));

      return;
    }
    if (await _isUserExists(email.toUpperCase())) {
      callback(const EventAlert(message: 'Mã sinh viên này đã được thêm rồi'));
      return;
    }
    callback(const EventLoadingMessage(message: 'Đang đăng nhập...'));
    await _loginReqest(email.toUpperCase(), password);
  }

  Future<bool> _isUserExists(String email) async {
    final allProfile = await _profileRepository.getUserByMSV(email);
    return allProfile != null;
  }

  Future<bool> _checkInternetConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      callback(const EventAlert(message: 'Không có kết nối mạng :('));
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<void> _loginReqest(String msv, String password) async {
    final result = await restClient.login(msv, password);
    _loginModel.msv = msv;
    if (result.isSuccess()) {
      _loginModel.profile = (result as LoginSuccess).message.profile;
      _loginModel.token = (result as LoginSuccess).message.Token;
      callback(const EventPop());
      callback(const EventLoadingMessage(message: 'Đang tải kỳ học'));

      await _getSemester(_loginModel.token);
    } else {
      callback(const EventPop());
      callback(const EventAlert(
          message: 'Mã sinh viên hoặc mật khẩu đăng nhập sai !'));
    }
  }

  Future<void> _getSemester(String token) async {
    logs('token is $token');
    final semesterResult = await restClient.getSemester(token);
    logs('semesterResult is ${semesterResult.toJson()}');
    callback(const EventPop());
    callback(EventAlertChonKyHoc(semesterResult: semesterResult));
  }

  /// handle when user clicked on semester picker dialog
  void semesterClicked(String data) {
    logs('data is $data');
    callback(const EventPop());
    _loginModel.semester = data;
    _loadData(data);
  }

  Future<void> _loadData(String semester) async {
    callback(const EventLoadingMessage(message: 'Đang lấy lịch học'));
    _loginModel.lichHoc =
        await restClient.getLichHoc(_loginModel.token, semester);
    callback(const EventPop());
    callback(const EventLoadingMessage(message: 'Đang lấy lịch thi'));
    _loginModel.lichThi =
        await restClient.getLichThi(_loginModel.token, semester);
    callback(const EventPop());
    await _saveInfo();
  }

  /// save profile, msv, schedule, mark ... to database
  Future<void> _saveInfo() async {
    callback(
        const EventLoadingMessage(message: 'Đang lưu thông tin người dùng'));
    final resProfile =
        await _profileRepository.insertOnlyUser(_loginModel.profile);
    callback(const EventPop());
    logs('saveProfileToDB: $resProfile');
    final resCurrentMSV =
        await SharedPrefs.instance.setCurrentMSV(_loginModel.msv);
    logs('saveCurrentMSV:$resCurrentMSV');
    callback(const EventLoadingMessage(message: 'Đang lưu lịch cá nhân'));
    await _saveMarkToDB();
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
    callback(const EventPop());
    callback(const EventSaveSuccess());
    await Future.delayed(const Duration(milliseconds: 800));
    callback(const EventPop());
  }

  Future<void> _saveMarkToDB() async {
    //TODO: save mark to db
//    var res = await PlatformChannel().saveMarkToDB(
//        mark, json.encode(subjectsName), json.encode(subjectsSoTinChi), msv);
//    print('saveMarkToDB: $res');
  }
}
