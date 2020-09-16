import 'dart:async';

import 'package:action_mixin/action_mixin.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import '../../../events/alert.dart';
import '../../../events/loading_message.dart';
import '../../../events/pop.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login.dart';
import '../../../models/entities/semester.dart';
import '../../../models/update_schedule.dart';
import '../../../services/http/rest_client.dart';
import '../../../services/local_storage/database/repository/profile_repository.dart';
import 'login_state.dart';

/// Login ChangeNotifier
class LoginNotifier with ActionMixin {
  /// Login ChangeNotifier
  LoginNotifier() {
    _loginState = LoginState();
    _updateSchedule = UpdateSchedule(ScheduleType.login);
  }

  UpdateSchedule _updateSchedule;
  LoginState _loginState;

  bool _dataIsInvalid(String email, String password) =>
      email.trim().isEmpty || password.trim().isEmpty;

  /// init action for UpdateSchedule
  void initActionUpdate(List<ActionEntry> actions) {
    _updateSchedule.initActions(actions);
  }

  /// call to UpdateSchedule.showAlertChonKyHoc
  void showAlertChonKyHoc(BuildContext context, SemesterResult semesterResult) {
    _updateSchedule.showAlertChonKyHoc(context, semesterResult);
  }

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
    final allProfile = await ProfileRepository.instance.getUserByMSV(email);
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
    _loginState.msv = msv;
    if (result.isSuccess()) {
      logs((result as LoginSuccess).toJson());
      _loginState.profile = (result as LoginSuccess).message.profile;
      _loginState.profile.Token = (result as LoginSuccess).message.Token;
      _loginState.token = (result as LoginSuccess).message.Token;
      callback(const EventPop());
      callback(const EventLoadingMessage(message: 'Đang tải kỳ học'));

      // request to get data by UpdateSchedule class
      _updateSchedule.loginState = _loginState;
      _updateSchedule.msv = _loginState.msv;
      _updateSchedule.token = _loginState.token;
      _updateSchedule.update();
    } else {
      callback(const EventPop());
      callback(const EventAlert(
          message: 'Mã sinh viên hoặc mật khẩu đăng nhập sai !'));
    }
  }
}
