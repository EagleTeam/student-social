import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:studentsocial/helpers/dialog_support.dart';
import 'package:studentsocial/presentation/screens/main/main_notifier.dart';

import '../../models/entities/semester.dart';

class UpdateSchedule extends StatefulWidget {
  const UpdateSchedule({this.mcontext});

  final BuildContext mcontext;

  @override
  _UpdateScheduleState createState() => _UpdateScheduleState();
}

class _UpdateScheduleState extends State<UpdateSchedule> {
  String lichHoc, lichThi;

  Map<String, String> subjectsName = <String, String>{};
  Map<String, String> subjectsSoTinChi = <String, String>{};

  @override
  void initState() {
    super.initState();
    _loadSemester();
  }

  Future<void> _loadSemester() async {
//    final SemesterResult result = await _netWorking.getSemester(_mainViewModel.getToken);
    Navigator.of(context).pop();
//    _showChonKiHoc(result);
  }

  void _alertWithMessage(String _msg) {
    final AlertDialog dialog = AlertDialog(
      content: Text(_msg),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  Future<void> loadData(String semester, String semester2) async {
    loadingMessage(widget.mcontext, 'Đang lấy lịch học');
//    lichHoc = await _netWorking.getLichHoc(_mainViewModel.getToken,semester);
    pop(widget.mcontext);
    loadingMessage(widget.mcontext, 'Đang lấy lịch thi');
//    lichThi = await _netWorking.getLichThi(_mainViewModel.getToken,semester);
    pop(widget.mcontext);
    if (semester2.isNotEmpty) {
      loadingMessage(widget.mcontext, 'Đang lấy lịch thi lại');
//      lichThiLai = await _netWorking.getLichThi(_mainViewModel.getToken,semester2);
      pop(widget.mcontext);
    }
    _saveInfo();
  }

  Future<void> _saveInfo() async {
    //tách và lấy ra tất cả tên và số tín chỉ của từng môn học
    addSubjects(lichHoc);
    addSubjects(lichThi);
    //validate lich hoc
    validateLichHoc();
    //validate lich thi
    validateLichThi();
    //Xoá lịch cũ và lưu lịch mới :))
    await removeScheduleOld();
    await saveScheduleToDB();
//    showSuccess(widget.mcontext,'Cập nhật lịch cá nhân hoàn tất');
    context.read(mainProvider).loadCurrentMSV();
  }

  Future<void> removeScheduleOld() async {
    //TODO: remove schedule old
//    var res = await PlatformChannel().deleteScheduleByMSVWithOutNote(_mainViewModel.getMSV);
  }

  Future<void> saveScheduleToDB() async {
    //TODO: save schedule to db
//    var res = await PlatformChannel().saveScheduleToDB(
//        lichHoc, lichThi, lichThiLai, _mainViewModel.getMSV, json.encode(subjectsName));
  }

  void validateLichHoc() {
    lichHoc = lichHoc.substring(lichHoc.indexOf('['));
    lichHoc = lichHoc.substring(0, lichHoc.indexOf(']') + 1);
  }

  void validateLichThi() {
    lichThi = lichThi.substring(lichThi.indexOf('['));
    lichThi = lichThi.substring(0, lichThi.indexOf(']') + 1);
  }

  void addSubjects(value) {
    final jsonValue = json.decode(value);
    final listSubjects = jsonValue['Subjects'];
    for (final item in listSubjects) {
      addSubjectsName(item['MaMon'], item['TenMon']);
      addSubjectsSoTinChi(item['MaMon'], item['SoTinChi'].toString());
    }
  }

  void addSubjectsName(maMon, tenMon) {
    subjectsName[maMon] = tenMon;
  }

  void addSubjectsSoTinChi(maMon, String soTinChi) {
    subjectsSoTinChi[maMon] = soTinChi;
  }

  Widget _layoutItemSemester(BuildContext context, data, data2) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Kỳ ${data['TenKy'].split('_')[0]} năm ${data['TenKy'].split('_')[1]}-${data['TenKy'].split('_')[2]}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                if (data2 != null) {
                  //co du lieu data2 => co lich thi lai
                }
                Navigator.of(widget.mcontext).pop();
                loadData(data['MaKy'], data2['MaKy']);
              },
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(height: 1)
          ],
        ));
  }

  void _showChonKiHoc(SemesterResult data) {
    final AlertDialog alertDialog = AlertDialog(
      title: const Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.message.length,
                itemBuilder: (BuildContext buildContext, int index) =>
                    _layoutItemSemester(
                        context,
                        data.message[index],
                        index < data.message.length - 1
                            ? data.message[index + 1]
                            : null),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  AlertDialog contentUpdateSchedule() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: const EdgeInsets.all(16),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: 30,
              height: 30,
              child: const Center(child: CircularProgressIndicator())),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Đang lấy danh sách kỳ học'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return contentUpdateSchedule();
  }
}
