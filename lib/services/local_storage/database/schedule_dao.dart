import 'package:studentsocial/models/entities/schedule.dart';

import '../../../helpers/logging.dart';
import 'database.dart';

class ScheduleDao {
  ScheduleDao(this.database);
  final MyDatabase database;

  Future<int> insertListSchedules(List<Schedule> listSchedules) async {
    logs('listSchedules is $listSchedules');
    for (int i = 0; i < listSchedules.length; i++) {
      final int result = await database.insert(listSchedules[i]);
      logs('result insert ${listSchedules[i].toJson()} is $result');
    }
    //TODO: edit value return
    return 0;
  }

  Future<int> insertOnlySchedule(Schedule schedule) async {
    return await database.insert(schedule);
  }

  Future<int> updateOnlySchedule(Schedule schedule) async {
    return await database.updateSchedule(schedule);
  }

  Future<int> deleteOnlySchedule(Schedule schedule) async {
    return await database.deleteSchedule(schedule.MaSinhVien);
  }

  Future<List<Schedule>> getAllSchedule(String msv) async {
    return await database.getAllSchedule(msv);
  }

  Future<int> deleteAllSchedule() async {
    return await database.deleteAll(Schedule.table);
  }

  Future<void> countSchedules() async {
    await database.count(Schedule.table);
  }

  Future<int> deleteScheduleByMSV(String msv) async {
    return await database.deleteSchedule(msv);
  }

  Future<int> deleteScheduleByMSVWithoutNote(String msv) async {
    return await database.deleteScheduleWithoutNote(msv);
  }

  Future<List<Schedule>> getAllScheduleFromDate(String msv, String date) {
    return database.getAllScheduleFromDate(msv, date);
  }
}
