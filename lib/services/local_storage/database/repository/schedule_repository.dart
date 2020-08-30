import 'package:intl/intl.dart';
import 'package:studentsocial/models/entities/schedule.dart';

import '../database.dart';
import '../schedule_dao.dart';

class ScheduleRepository {
  ScheduleRepository(MyDatabase database) {
    dao = ScheduleDao(database);
  }

  ScheduleDao dao;

  Future<List<Schedule>> getListSchedules(String msv) async {
    return await dao.getAllSchedule(msv);
  }

  Future<int> insertListSchedules(List<Schedule> listSchedules) async {
    return await dao.insertListSchedules(listSchedules);
  }

  Future<int> insertOnlySchedule(Schedule schedule) async {
    return await dao.insertOnlySchedule(schedule);
  }

  Future<int> deleteOnlySchedule(Schedule schedule) async {
    return await dao.deleteOnlySchedule(schedule);
  }

  Future<int> deleteScheduleByMSV(String msv) async {
    return await dao.deleteScheduleByMSV(msv);
  }

  Future<int> deleteScheduleByMSVWithOutNote(String msv) async {
    return await dao.deleteScheduleByMSVWithoutNote(msv);
  }

  Future<int> deleteAllSchedules() async {
    return await dao.deleteAllSchedule();
  }

  Future<int> updateOnlySchedule(Schedule schedule) async {
    return await dao.updateOnlySchedule(schedule);
  }

  Future<void> countSchedules() async {
    return dao.countSchedules();
  }

  Future<List<Schedule>> getListScheduleByDateAndMSV(
      DateTime date, String msv) async {
    final String strDate = DateFormat('yyyy-MM-dd').format(date);
    return await dao.getAllScheduleFromDate(msv, strDate);
  }
}
