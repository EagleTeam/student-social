import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';

class MainModel {
  double width = 0;
  double itemWidth = 0;
  double itemHeight = 250 / 6;
  double drawerHeaderHeight = 300;

  // title = 25, titleday = 25, tableheight = 250 , 16 margin
  double tableHeight = 316;
  String title = 'Student Social';
  String name = 'Tên sinh viên';
  String className = 'Lớp';

  // mặc định msv là khách để khách có thể dùng bình thường
  String msv = 'guest';

  Profile profile;
  List<Profile> allProfile;
  List<Schedule> _schedules = [];
  Map<String, List<Schedule>> entriesOfDay;

  DateTime clickDate = DateTime.now();
  DateTime currentDate = DateTime.now();

  List<Schedule> get schedules => _schedules;

  set schedules(List<Schedule> schedules) {
    _schedules = schedules..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  String get keyOfCurrentEntries {
    return '${getNum(clickDate.year)}-${getNum(clickDate.month)}-${getNum(clickDate.day)}';
  }

  String getNum(int n) {
    if (n < 10) {
      return '0$n';
    }
    return '$n';
  }

  static const List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple
  ];

  bool get entriesOfDayNotEmpty =>
      entriesOfDay != null && entriesOfDay.isNotEmpty;

  void initSize(Size size) {
    width = size.width;
    itemWidth = width / 7;
  }

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
    msv = '';
    profile = null;
    _schedules = List.from(_schedules..clear());
    entriesOfDay?.clear();
  }
}
