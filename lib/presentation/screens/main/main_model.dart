// Project imports:
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';

class MainModel {
  String name = 'Tên sinh viên';
  String className = 'Lớp';

  Profile profile;
  List<Profile> allProfile;
  List<Schedule> _schedules = [];
  Map<String, List<Schedule>> entriesOfDay;

  List<Schedule> get schedules => _schedules;

  set schedules(List<Schedule> schedules) {
    _schedules = schedules..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  bool get entriesOfDayNotEmpty =>
      entriesOfDay != null && entriesOfDay.isNotEmpty;

  void clearEntriesOfDay() {
    entriesOfDay.clear();
  }

  void initEntriesOfDayIfNeed() {
    entriesOfDay ??= <String, List<Schedule>>{};
  }

  void initEntriesIfNeed(String ngay) {
    if (entriesOfDay[ngay] == null) {
      entriesOfDay[ngay] = <Schedule>[];
      // neu ngay cua entri nay chua co lich thi phai khoi tao trong map 1 list de luu lai duoc,
      //neu co roi thi thoi dung tiep
    }
  }

  void addScheduleToEntriesOfDay(Schedule lich) {
    entriesOfDay[lich.getNgay].add(lich);
  }

  void resetData() {
    profile = null;
    _schedules = List.from(_schedules..clear());
    entriesOfDay?.clear();
  }
}
