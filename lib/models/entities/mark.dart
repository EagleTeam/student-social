// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'db_parseable.dart';

part 'mark.g.dart';

@JsonSerializable()
class Mark extends DBParseable {
  static const table = 'Mark';
  static const createQuery = '''CREATE TABLE IF NOT EXISTS Mark (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  MaSinhVien TEXT,
  MaMon TEXT,
  TenMon TEXT,
  SoTinChi TEXT,
  CC TEXT,
  KT TEXT,
  THI TEXT,
  TKHP TEXT,
  DIEMCHU TEXT
  )''';
  static const dropQuery = 'DROP TABLE IF EXISTS Mark;';
  final int ID;
  final String MaSinhVien;
  final String MaMon;
  final String TenMon;
  final String SoTinChi;
  final String CC;
  final String KT;
  final String THI;
  final String TKHP;
  final String DiemChu;

  Mark(
      {this.ID,
      this.MaSinhVien,
      this.MaMon,
      this.TenMon,
      this.SoTinChi,
      this.CC,
      this.KT,
      this.THI,
      this.TKHP,
      this.DiemChu});

  factory Mark.fromJson(Map<String, dynamic> json) => _$MarkFromJson(json);

  Map<String, dynamic> toJson() => _$MarkToJson(this);

  @override
  String get tableName => 'Mark';
}
