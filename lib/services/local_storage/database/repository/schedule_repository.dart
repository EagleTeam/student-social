// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import '../../../../helpers/logging.dart';
import '../../../../models/entities/schedule.dart';
import '../database.dart';

class ScheduleRepository {
  ScheduleRepository._();

  static ScheduleRepository _instance;

  static ScheduleRepository get instance {
    _instance ??= ScheduleRepository._();
    return _instance;
  }

  MyDatabase get database => MyDatabase.instance;

  Future<List<Schedule>> getListSchedules(String msv) async {
    return database.getAllSchedule(msv);
  }

  Future<int> insertListSchedules(List<Schedule> listSchedules) async {
    logs('listSchedules is $listSchedules');
    for (var i = 0; i < listSchedules.length; i++) {
      final result = await database.insert(listSchedules[i]);
      logs('result insert ${listSchedules[i].toJson()} is $result');
    }
    //TODO: edit value return
    return 0;
  }

  Future<int> insertOnlySchedule(Schedule schedule) async {
    return database.insert(schedule);
  }

  Future<int> deleteOnlySchedule(Schedule schedule) async {
    return database.deleteSchedule(schedule.MaSinhVien);
  }

  Future<int> deleteScheduleByMSV(String msv) async {
    return database.deleteSchedule(msv);
  }

  Future<int> deleteScheduleByMSVWithOutNote(String msv) async {
    return database.deleteScheduleWithoutNote(msv);
  }

  Future<int> deleteAllSchedules() async {
    return database.deleteAll(Schedule.table);
  }

  Future<int> updateOnlySchedule(Schedule schedule) async {
    return database.updateSchedule(schedule);
  }

  Future<void> countSchedules() async {
    return database.count(Schedule.table);
  }

  Future<List<Schedule>> getListScheduleByDateAndMSV(
      DateTime date, String msv) async {
    final strDate = DateFormat('yyyy-MM-dd').format(date);
    return database.getAllScheduleFromDate(msv, strDate);
  }
}
