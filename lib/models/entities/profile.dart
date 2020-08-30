import 'package:json_annotation/json_annotation.dart';
import 'db_parseable.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends DBParseable {
  static const String table = 'Profile';
  static const String createQuery = '''CREATE TABLE IF NOT EXISTS Profile (
  MaSinhVien TEXT PRIMARY KEY,
  HoTen TEXT,
  NienKhoa TEXT,
  Lop TEXT,
  Nganh TEXT,
  Truong TEXT,
  HeDaoTao TEXT,
  TongTC TEXT,
  STCTD TEXT,
  STCTLN TEXT,
  DTBC TEXT,
  DTBCQD TEXT,
  SoMonKhongDat TEXT,
  SoTCKhongDat TEXT,
  Token TEXT
  )''';
  static const dropQuery = 'DROP TABLE IF EXISTS Profile;';
  final String MaSinhVien;
  final String HoTen;
  final String NienKhoa;
  final String Lop;
  final String Nganh;
  final String Truong;
  final String HeDaoTao;
  String TongTC;
  String STCTD;
  String STCTLN;
  String DTBC;
  String DTBCQD;
  String SoMonKhongDat;
  String SoTCKhongDat;
  String Token;

  Profile(
      {this.MaSinhVien,
      this.HoTen,
      this.NienKhoa,
      this.Lop,
      this.Nganh,
      this.Truong,
      this.HeDaoTao});

  void setMoreDetail(
      tongtc, stctd, stctln, dtbc, dtbcqd, somonkhongdat, sotckhongdat, token) {
    this.TongTC = tongtc.toString();
    this.STCTD = stctd.toString();
    this.STCTLN = stctln.toString();
    this.DTBC = dtbc.toString();
    this.DTBCQD = dtbcqd.toString();
    this.SoMonKhongDat = somonkhongdat.toString();
    this.SoTCKhongDat = sotckhongdat.toString();
    this.Token = token;
  }

  void setMoreDetailByJson(Map<String, dynamic> json) {
    this.TongTC = json['TongTC'].toString();
    this.STCTD = json['STCTD'].toString();
    this.STCTLN = json['STCTLN'].toString();
    this.DTBC = json['DTBC'].toString();
    this.DTBCQD = json['DTBCQD'].toString();
    this.SoMonKhongDat = json['SoMonKhongDat'].toString();
    this.SoTCKhongDat = json['SoTCKhongDat'].toString();
    this.Token = json['Token'].toString();
  }

  factory Profile.guest() {
    return Profile(MaSinhVien: 'guest', HoTen: 'Người dùng thông thường');
  }

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  String get tableName => 'Profile';
}
