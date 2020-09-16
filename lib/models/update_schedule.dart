import 'package:action_mixin/action_mixin.dart';
import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:studentsocial/events/alert_chon_kyhoc.dart';
import 'package:studentsocial/events/loading_message.dart';
import 'package:studentsocial/events/pop.dart';
import 'package:studentsocial/events/save_success.dart';
import 'package:studentsocial/helpers/logging.dart';
import 'package:studentsocial/presentation/screens/login/login_state.dart';
import 'package:studentsocial/services/http/rest_client.dart';
import 'package:studentsocial/services/local_storage/database/repository/profile_repository.dart';
import 'package:studentsocial/services/local_storage/database/repository/schedule_repository.dart';
import 'package:studentsocial/services/local_storage/shared_prefs.dart';

import 'entities/schedule.dart';
import 'entities/semester.dart';

enum ScheduleType { login, update }

class UpdateSchedule with ActionMixin {
  UpdateSchedule(this._type);

  final ScheduleType _type;
  String _token;
  LoginState _loginState = LoginState();

  set msv(String msv) {
    _loginState.msv = msv;
  }

  set token(String token) {
    _token = token;
    _loginState.token = token;
  }

  set loginState(LoginState loginState) {
    _loginState = loginState;
  }

  void update() {
    _getSemester();
  }

  Future<void> _getSemester() async {
    logs('token is $_token');
    final semesterResult = await restClient.getSemester(_token);
    logs('semesterResult is ${semesterResult.toJson()}');
    callback(const EventPop());
    callback(EventAlertChonKyHoc(semesterResult: semesterResult));
  }

  /// handle when user clicked on semester picker dialog
  void semesterClicked(String data) {
    logs('data is $data');
    callback(const EventPop());
    _loginState.semester = data;
    _loadData(data);
  }

  Future<void> _loadData(String semester) async {
    callback(const EventLoadingMessage(message: 'Đang lấy lịch học'));
    _loginState.lichHoc =
        await restClient.getLichHoc(_loginState.token, semester);
    callback(const EventPop());
    callback(const EventLoadingMessage(message: 'Đang lấy lịch thi'));
    _loginState.lichThi =
        await restClient.getLichThi(_loginState.token, semester);
    callback(const EventPop());
    await _saveInfo();
  }

  /// save profile, msv, schedule, mark ... to database
  Future<void> _saveInfo() async {
    if (_type == ScheduleType.login) {
      callback(
          const EventLoadingMessage(message: 'Đang lưu thông tin người dùng'));
      logs('save profile is ${_loginState.profile}');
      final resProfile =
          await ProfileRepository.instance.insertOnlyUser(_loginState.profile);
      callback(const EventPop());
      logs('saveProfileToDB: $resProfile');
      final resCurrentMSV =
          await SharedPrefs.instance.setCurrentMSV(_loginState.msv);
      logs('saveCurrentMSV:$resCurrentMSV');
    }

    callback(const EventLoadingMessage(message: 'Đang lưu lịch cá nhân'));
    // delete all schedule old
    await ScheduleRepository.instance.deleteScheduleByMSV(_loginState.msv);
    await _saveMarkToDB();
    if (_loginState.lichHoc.isSuccess()) {
      (_loginState.lichHoc as ScheduleSuccess).message.addMSV(_loginState.msv);
      await ScheduleRepository.instance.insertListSchedules(
          (_loginState.lichHoc as ScheduleSuccess).message.Entries);
    }
    if (_loginState.lichThi.isSuccess()) {
      (_loginState.lichThi as ScheduleSuccess).message.addMSV(_loginState.msv);
      await ScheduleRepository.instance.insertListSchedules(
          (_loginState.lichThi as ScheduleSuccess).message.Entries);
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

  /// *************** widget dialog support
  void showAlertChonKyHoc(BuildContext context, SemesterResult data) {
    final alertDialog = AlertDialog(
      title: const Text('Chọn kỳ học'),
      content: BoxOfScreen(
        widthPercent: 80,
        heightPercent: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.message.length,
                itemBuilder: (buildContext, index) =>
                    _itemKyHoc(context, data.message[index]),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget _itemKyHoc(BuildContext context, Semester data) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Kỳ ${data.TenKy.split('_')[0]} năm ${data.TenKy.split('_')[1]}-${data.TenKy.split('_')[2]}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                semesterClicked(data.MaKy);
              },
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(
              height: 1,
            )
          ],
        ));
  }
}
