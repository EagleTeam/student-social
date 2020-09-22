// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:studentsocial/helpers/date.dart';
import 'package:studentsocial/helpers/logging.dart';
import 'db_parseable.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule extends DBParseable {
  static const table = 'Schedule';
  static const createQuery = '''CREATE TABLE IF NOT EXISTS Schedule (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  MaSinhVien TEXT,
  MaMon TEXT,
  HocPhan TEXT,
  ThoiGian TEXT,
  TietHoc TEXT,
  Ngay TEXT,
  DiaDiem TEXT,
  HinhThuc TEXT,
  GiaoVien TEXT,
  LoaiLich TEXT,
  SoBaoDanh TEXT,
  SoTinChi TEXT
  )''';
  static const String dropQuery = 'DROP TABLE IF EXISTS Schedule;';
  final int ID;

  String MaSinhVien;

  String MaMon;

  final String HocPhan;

  String ThoiGian;

  final String TietHoc;

  final String Ngay;

  final String DiaDiem;

  final String HinhThuc;

  final String GiaoVien;

  final String LoaiLich;

  final String SoBaoDanh;

  final String SoTinChi;

  Schedule(
      {this.ID,
      this.MaSinhVien,
      this.MaMon,
      this.HocPhan,
      this.ThoiGian,
      this.Ngay,
      this.TietHoc,
      this.DiaDiem,
      this.HinhThuc,
      this.GiaoVien,
      this.LoaiLich,
      this.SoBaoDanh,
      this.SoTinChi});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);

  Map<String, dynamic> toMap() => _$ScheduleToJson(this);

  bool equalsDate(DateTime date) {
    final List<int> varsDate =
        getNgay.split('/').map((e) => int.parse(e)).toList();
    return date.year == varsDate[2] &&
        date.month == varsDate[1] &&
        date.day == varsDate[0];
  }

  String get diaDiemClean {
    if (!DiaDiem.contains('_')) {
      return DiaDiem;
    }
    return DiaDiem.split('_')[0];
  }

  String get hocPhanClean {
    if (!HocPhan.contains('-')) {
      return HocPhan;
    }
    return HocPhan.split('-')[0];
  }

  DateTime get startTime {
    final varsDate = getNgay.split('/');
    if (LoaiLich == 'LichThi') {
      final varsTiet = TietHoc.replaceAll(')', '').split('(')[1].split('-');
      final start = varsTiet[0].trim().split(':');
      return DateTime(int.parse(varsDate[2]), int.parse(varsDate[1]),
          int.parse(varsDate[0]), int.parse(start[0]), int.parse(start[1]));
    } else {
      final varsTiet = thoiGian.split('-');
      final start = varsTiet[0].trim().split(':');
      return DateTime(int.parse(varsDate[2]), int.parse(varsDate[1]),
          int.parse(varsDate[0]), int.parse(start[0]), int.parse(start[1]));
    }
  }

  DateTime get endTime {
    final varsDate = getNgay.split('/');
    if (LoaiLich == 'LichThi') {
      final varsTiet = TietHoc.replaceAll(')', '').split('(')[1].split('-');
      final end = varsTiet[1].trim().split(':');
      return DateTime(int.parse(varsDate[2]), int.parse(varsDate[1]),
          int.parse(varsDate[0]), int.parse(end[0]), int.parse(end[1]));
    } else {
      final varsTiet = thoiGian.split('-');
      final end = varsTiet[1].trim().split(':');
      return DateTime(int.parse(varsDate[2]), int.parse(varsDate[1]),
          int.parse(varsDate[0]), int.parse(end[0]), int.parse(end[1]));
    }
  }

  String get getNgay {
    // ket qua cuoi cung mong muon = dd/mm/yyyy
    if (ThoiGian.contains('/')) {
      // no se co dang dd/mm/yyyy
      return ThoiGian;
    } else {
      // no se co dang yyyy-mm-ddXXXXXXXXXX
      final List<String> varsDate =
          ThoiGian.substring(0, 10).replaceAll('-', '/').split('/');
//      logs('getNgay is ${varsDate[2]}/${varsDate[1]}/${varsDate[0]}');
      return '${varsDate[2]}/${varsDate[1]}/${varsDate[0]}';
    }
  }

  String get thoiGian {
    if (LoaiLich == 'LichThi') {
      return TietHoc;
    }
    DateSupport dateSupport = DateSupport();
    return dateSupport.getThoiGian(TietHoc, MaSinhVien);
  }

  factory Schedule.forNote(
      String msv, String tieuDe, String noiDung, String ngay) {
    return Schedule(
        MaSinhVien: msv,
        MaMon: tieuDe,
        ThoiGian: noiDung,
        Ngay: ngay,
        LoaiLich: 'Note');
  }

  void addMSV(String msv) {
    MaSinhVien = msv;
  }

  //sinh chuỗi để tạo note từ object hiện có
  String toStringForNote() {
    return jsonEncode(this);
//    return "{\"ID\":\"$ID\",\"MaSinhVien\":\"$MaSinhVien\",\"MaMon\":\"$MaMon\",\"TenMon\":\"$TenMon\",\"ThoiGian\":\"$ThoiGian\",\"Ngay\":\"$Ngay\",\"DiaDiem\":\"$DiaDiem\",\"HinhThuc\":\"$HinhThuc\",\"GiaoVien\":\"$GiaoVien\",\"LoaiLich\":\"$LoaiLich\",\"SoBaoDanh\":\"$SoBaoDanh\",\"SoTinChi\":\"$SoTinChi\"}";
  }

  bool equals(Schedule schedule) {
    return MaSinhVien == schedule.MaSinhVien &&
        MaMon == schedule.MaMon &&
        HocPhan == schedule.HocPhan &&
        ThoiGian == schedule.ThoiGian &&
        Ngay == schedule.Ngay &&
        DiaDiem == schedule.DiaDiem &&
        HinhThuc == schedule.HinhThuc &&
        GiaoVien == schedule.GiaoVien &&
        LoaiLich == schedule.LoaiLich &&
        SoBaoDanh == schedule.SoBaoDanh &&
        SoTinChi == schedule.SoTinChi;
  }

  @override
  String get tableName => 'Schedule';
}

@JsonSerializable()
class ScheduleMessage {
  ScheduleMessage({this.Entries});

  List<Schedule> Entries;

  factory ScheduleMessage.fromJson(Map<String, dynamic> json) =>
      _$ScheduleMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleMessageToJson(this);

  void addMSV(String msv) {
    for (final Schedule entry in Entries) {
      entry.addMSV(msv);
    }
  }
}

@JsonSerializable()
class ScheduleSuccess implements ScheduleResult {
  factory ScheduleSuccess.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleSuccessToJson(this);

  ScheduleSuccess({
    this.status,
    this.message,
  });

  String status;
  ScheduleMessage message;

  @override
  bool isSuccess() {
    return status == 'success';
  }
}

@JsonSerializable()
class ScheduleFail implements ScheduleResult {
  factory ScheduleFail.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFailFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleFailToJson(this);

  ScheduleFail({this.status, this.message});

  String status;
  String message;

  @override
  bool isSuccess() {
    return status != 'success';
  }
}

abstract class ScheduleResult {
  factory ScheduleResult.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'success') {
      return ScheduleSuccess.fromJson(json);
    } else {
      return ScheduleFail.fromJson(json);
    }
  }

  bool isSuccess();
}
