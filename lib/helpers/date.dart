class DateSupport {
  DateSupport() {
    _now = DateTime.now();
    _initTime();
  }

  DateSupport.fromDate(this._now);

  DateSupport.frommUTC(int y, int m, int d) {
    _now = DateTime(y, m, d);
  }

  DateTime _now;
  List<String> _time1, _time2;

  void _initTime() {
    _time1 = [
      '06:30 - 07:20',
      '07:25 - 08:15',
      '08:25 - 09:15',
      '09:25 - 10:15',
      '10:20 - 11:10',
      '13:00 - 13:50',
      '13:55 - 14:45',
      '14:55 - 15:45',
      '15:55 - 16:45',
      '16:50 - 17:40',
      '18:15 - 19:05',
      '19:10 - 20:00'
    ];
    _time2 = [
      '06:45 - 07:35',
      '07:40 - 08:30',
      '08:40 - 09:30',
      '09:40 - 10:30',
      '10:35 - 11:25',
      '13:00 - 13:50',
      '13:55 - 14:45',
      '14:55 - 15:45',
      '15:55 - 16:45',
      '16:50 - 17:40',
      '18:15 - 19:05',
      '19:10 - 20:00'
    ];
  }

  String format(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime getDate(int day) {
    DateTime date = DateTime(getYear(), getMonth(), getDay(), 19, 30);
    date = date.add(Duration(days: day));
    return date;
  }

  DateTime getDateNow() {
    return _now;
  }

  int getDay() {
    return _now.day;
  }

  int getMonth() {
    return _now.month;
  }

  int getYear() {
    return _now.year;
  }

  int getDayOfWeek() {
    return _now.weekday;
  }

  int getMaxDayOfMonth(int year, int month) {
//    print(DateTime(year,month+1,0));
    //datetime(year,month+1,0) tuong duong voi ngay cuoi cung cua thang truoc no
    // 0/12/2018 => 30/11/2018
    return DateTime(year, month + 1, 0).day;
  }

  int getIndexDayOfWeek(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }

  int getMonthByIndex(int index, int mode) {
    final int delta = index - 12; // 12 la indexpage mac dinh
    if (mode == 1) {
      return DateTime(_now.year, _now.month + delta, _now.day).month;
    } else {
      return DateTime(_now.year, _now.month + delta, _now.day).year;
    }
  }

  int _getMua() {
    /**
     * return 1 neu la mua he
     * return 2 neu la mua dong
     * mua he bat dau tu 15/4
     * mua dong bat dau tu 15/10
     */
    final int m = _now.month;
    final int d = _now.day;
    if ([1, 2, 3, 11, 12].contains(m)) {
      return 2;
    }
    if (m == 4) {
      if (d >= 15) {
        return 1;
      } else {
        return 2;
      }
    }
    if (m == 10) {
      if (d >= 15) {
        return 2;
      } else {
        return 1;
      }
    }
    return 1;
  }

  int getTiet(String msv) {
    if (msv.startsWith('DTC')) {
      _time1 = [
        '06:30 - 07:20',
        '07:25 - 08:15',
        '08:25 - 09:15',
        '09:25 - 10:15',
        '10:20 - 11:10',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:55 - 15:45',
        '15:55 - 16:45',
        '16:50 - 17:40',
        '18:15 - 19:05',
        '19:10 - 20:00'
      ];
      _time2 = [
        '06:45 - 07:35',
        '07:40 - 08:30',
        '08:40 - 09:30',
        '09:40 - 10:30',
        '10:35 - 11:25',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:55 - 15:45',
        '15:55 - 16:45',
        '16:50 - 17:40',
        '18:15 - 19:05',
        '19:10 - 20:00'
      ];
    }
    if (msv.startsWith('DTE')) {
      _time1 = [
        '06:45 - 07:35',
        '07:40 - 08:30',
        '08:35 - 09:25',
        '09:30 - 10:20',
        '10:25 - 11:15',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:50 - 15:40',
        '15:55 - 16:35',
        '16:40 - 17:30',
        '18:15 - 19:05',
        '19:10 - 20:00',
        '20:05 - 20:55',
        '21:00 - 21:55',
        '21:55 - 22:45',
      ];
      _time2 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:45 - 10:35',
        '10:40 - 11:30',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:50 - 15:40',
        '15:55 - 16:35',
        '16:40 - 17:30',
        '18:15 - 19:05',
        '19:10 - 20:00',
        '20:05 - 20:55',
        '21:00 - 21:55',
        '21:55 - 22:45',
      ];
    }
    if (msv.startsWith('DTN')) {
      _time1 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:50 - 10:40',
        '10:45 - 11:35',
        '13:15 - 14:05',
        '14:10 - 15:00',
        '15:05 - 15:55',
        '16:05 - 16:55',
        '17:00 - 17:50',
      ];
      _time2 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:50 - 10:40',
        '10:45 - 11:35',
        '13:15 - 14:05',
        '14:10 - 15:00',
        '15:05 - 15:55',
        '16:05 - 16:55',
        '17:00 - 17:50',
      ];
    }
    final List<String> time = _getTimeByMua();

    for (int i = 0; i < time.length; i++) {
      final String _time1 = time[i].split('-')[0];
      final String _time2 = time[i].split('-')[1];
      final int h1 = int.parse(_time1.split(':')[0]);
      final int m1 = int.parse(_time1.split(':')[1]);
      final int h2 = int.parse(_time2.split(':')[0]);
      final int m2 = int.parse(_time2.split(':')[1]);
      final int date1 = DateTime(_now.year, _now.month, _now.day, h1, m1)
          .millisecondsSinceEpoch;
      final int date2 = DateTime(_now.year, _now.month, _now.day, h2, m2)
          .millisecondsSinceEpoch;
      if (DateTime.now().millisecondsSinceEpoch >= date1 &&
          DateTime.now().millisecondsSinceEpoch <= date2) {
        return i + 1;
      }
    }
    return 0;
  }

  List<String> _getTimeByMua() {
    final mua = _getMua();
    if (mua == 1) {
      return _time1;
    }
    return _time2;
  }

  String getThoiGian(String thoiGian, String msv) {
    if (msv.startsWith('DTC')) {
      _time1 = [
        '06:30 - 07:20',
        '07:25 - 08:15',
        '08:25 - 09:15',
        '09:25 - 10:15',
        '10:20 - 11:10',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:55 - 15:45',
        '15:55 - 16:45',
        '16:50 - 17:40',
        '18:15 - 19:05',
        '19:10 - 20:00'
      ];
      _time2 = [
        '06:45 - 07:35',
        '07:40 - 08:30',
        '08:40 - 09:30',
        '09:40 - 10:30',
        '10:35 - 11:25',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:55 - 15:45',
        '15:55 - 16:45',
        '16:50 - 17:40',
        '18:15 - 19:05',
        '19:10 - 20:00'
      ];
    }
    if (msv.startsWith('DTE')) {
      _time1 = [
        '06:45 - 07:35',
        '07:40 - 08:30',
        '08:35 - 09:25',
        '09:30 - 10:20',
        '10:25 - 11:15',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:50 - 15:40',
        '15:55 - 16:35',
        '16:40 - 17:30',
        '18:15 - 19:05',
        '19:10 - 20:00',
        '20:05 - 20:55',
        '21:00 - 21:55',
        '21:55 - 22:45',
      ];
      _time2 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:45 - 10:35',
        '10:40 - 11:30',
        '13:00 - 13:50',
        '13:55 - 14:45',
        '14:50 - 15:40',
        '15:55 - 16:35',
        '16:40 - 17:30',
        '18:15 - 19:05',
        '19:10 - 20:00',
        '20:05 - 20:55',
        '21:00 - 21:55',
        '21:55 - 22:45',
      ];
    }
    if (msv.startsWith('DTN')) {
      _time1 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:50 - 10:40',
        '10:45 - 11:35',
        '13:15 - 14:05',
        '14:10 - 15:00',
        '15:05 - 15:55',
        '16:05 - 16:55',
        '17:00 - 17:50',
      ];
      _time2 = [
        '07:00 - 07:50',
        '07:55 - 08:45',
        '08:50 - 09:40',
        '09:50 - 10:40',
        '10:45 - 11:35',
        '13:15 - 14:05',
        '14:10 - 15:00',
        '15:05 - 15:55',
        '16:05 - 16:55',
        '17:00 - 17:50',
      ];
    }
    final int mua = _getMua();
    if (thoiGian.contains(',')) {
      //co nhieu hon 1 tiet
      final List<String> tiets = thoiGian.split(',');
      final int first = int.parse(tiets[0]);
      final int last = int.parse(tiets[tiets.length - 1]);

      if (mua == 1) {
        //mua he lay lich _time1
        return '${_time1[first - 1].split('-')[0]}-${_time1[last - 1].split('-')[1]}';
      } else {
        return '${_time2[first - 1].split('-')[0]}-${_time2[last - 1].split('-')[1]}';
      }
    } else {
      //chi co 1 tiet :v
      final tiet = int.parse(thoiGian);
      if (mua == 1) {
        //mua he lay lich _time1
        return '${_time1[tiet - 1].split('-')[0]}-${_time1[tiet - 1].split('-')[1]}';
      } else {
        return '${_time2[tiet - 1].split('-')[0]}-${_time2[tiet - 1].split('-')[1]}';
      }
    }
  }

  int getHour() {
    return _now.hour;
  }

  int getMinute() {
    return _now.minute;
  }
}
