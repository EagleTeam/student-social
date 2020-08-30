// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    MaSinhVien: json['MaSinhVien'] as String,
    HoTen: json['HoTen'] as String,
    NienKhoa: json['NienKhoa'] as String,
    Lop: json['Lop'] as String,
    Nganh: json['Nganh'] as String,
    Truong: json['Truong'] as String,
    HeDaoTao: json['HeDaoTao'] as String,
  )
    ..TongTC = json['TongTC'] as String
    ..STCTD = json['STCTD'] as String
    ..STCTLN = json['STCTLN'] as String
    ..DTBC = json['DTBC'] as String
    ..DTBCQD = json['DTBCQD'] as String
    ..SoMonKhongDat = json['SoMonKhongDat'] as String
    ..SoTCKhongDat = json['SoTCKhongDat'] as String
    ..Token = json['Token'] as String;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'MaSinhVien': instance.MaSinhVien,
      'HoTen': instance.HoTen,
      'NienKhoa': instance.NienKhoa,
      'Lop': instance.Lop,
      'Nganh': instance.Nganh,
      'Truong': instance.Truong,
      'HeDaoTao': instance.HeDaoTao,
      'TongTC': instance.TongTC,
      'STCTD': instance.STCTD,
      'STCTLN': instance.STCTLN,
      'DTBC': instance.DTBC,
      'DTBCQD': instance.DTBCQD,
      'SoMonKhongDat': instance.SoMonKhongDat,
      'SoTCKhongDat': instance.SoTCKhongDat,
      'Token': instance.Token,
    };
