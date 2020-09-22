// Flutter imports:
import 'package:flutter/services.dart';

class PlatformChannel {
  static const MethodChannel database =
      const MethodChannel('eagleteam.studentsocial/database');
  static const setSchedule = 'setSchedule';
  static const getSchedule = 'getSchedule';
  static const removeSchedule = 'removeSchedule';
  static const removeScheduleByMSV = 'removeScheduleByMSV';
  static const removeOneSchedule =
      'removeOneSchedule'; //cái này chỉ dành cho việc xoá ghi chú
  static const updateOneSchedule = 'updateOneSchedule'; //same

  static const setLichHoc = 'setLichHoc';
  static const getLichHoc = 'getLichHoc';
  static const removeLichHoc = 'removeLichHoc';

  static const setLichThi = 'setLichThi';
  static const getLichThi = 'getLichThi';
  static const removeLichThi = 'removeLichThi';

  static const setLichThiLai = 'setLichThiLai';
  static const getLichThiLai = 'getLichThiLai';
  static const removeLichThiLai = 'removeLichThiLai';

  static const setMark = 'setMark';
  static const getMark = 'getMark';
  static const removeMark = 'removeMark';
  static const removeMarkByMSV = 'removeMarkByMSV';

  static const setProfile = 'setProfile';
  static const getProfile = 'getProfile';
  static const removeProfile = 'removeProfile';
  static const removeProfileByMSV = 'removeProfileByMSV';
  static const getAllProfile = 'getAllProfile';

  static const setCurrentMSV = 'setCurrentMSV';
  static const getCurrentMSV = 'getCurrentMSV';

  static const addNote = 'addNote';

  Future<String> saveCurrentMSV(String msv) async {
    try {
      final String result = await PlatformChannel.database.invokeMethod(
          PlatformChannel.setCurrentMSV, <String, String>{'msv': msv});
      return result;
    } on PlatformException catch (e) {
      return 'ERROR: $e';
    }
  }

  Future<String> loadCurrentMSV(String msv) async {
    try {
      final String result = await PlatformChannel.database
          .invokeMethod(PlatformChannel.getCurrentMSV);
      return result;
    } on PlatformException catch (e) {
      return 'ERROR: $e';
    }
  }

  Future<String> saveProfileToDB(String data) async {
    try {
      final String result = await PlatformChannel.database.invokeMethod(
          PlatformChannel.setProfile, <String, String>{'data': data});
      return result;
    } on PlatformException catch (e) {
      return 'ERROR: $e';
    }
  }

  Future<String> saveMarkToDB(
      String data, String name, String stc, String msv) async {
    try {
      final String result = await PlatformChannel.database.invokeMethod(
          PlatformChannel.setMark,
          <String, String>{'data': data, 'name': name, 'stc': stc, 'msv': msv});
      return 'SUCCESS: $result';
    } on PlatformException catch (e) {
      return 'ERROR: $e';
    }
  }

  Future<String> saveScheduleToDB(String LichHoc, String LichThi,
      String LichThiLai, String msv, String tenmon) async {
    try {
      final String result = await PlatformChannel.database
          .invokeMethod(PlatformChannel.setSchedule, <String, String>{
        'lichhoc': LichHoc,
        'lichthi': LichThi,
        'lichthilai': LichThiLai,
        'msv': msv,
        'tenmon': tenmon
      });
      return 'SUCCESS: $result';
    } on PlatformException catch (e) {
      return 'ERROR: $e';
    }
  }

  Future<String> getSchedules() async {
    return await PlatformChannel.database
        .invokeMethod(PlatformChannel.getSchedule);
  }

  Future<String> deleteScheduleByMSVWithOutNote(String getMSV) async {
    return await PlatformChannel.database.invokeMethod(
        PlatformChannel.removeScheduleByMSV,
        <String, String>{'msv': getMSV, 'type': 'note'});
  }
}
