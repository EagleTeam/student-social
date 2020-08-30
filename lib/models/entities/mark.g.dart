// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mark _$MarkFromJson(Map<String, dynamic> json) {
  return Mark(
    ID: json['ID'] as int,
    MaSinhVien: json['MaSinhVien'] as String,
    MaMon: json['MaMon'] as String,
    TenMon: json['TenMon'] as String,
    SoTinChi: json['SoTinChi'] as String,
    CC: json['CC'] as String,
    KT: json['KT'] as String,
    THI: json['THI'] as String,
    TKHP: json['TKHP'] as String,
    DiemChu: json['DiemChu'] as String,
  );
}

Map<String, dynamic> _$MarkToJson(Mark instance) => <String, dynamic>{
      'ID': instance.ID,
      'MaSinhVien': instance.MaSinhVien,
      'MaMon': instance.MaMon,
      'TenMon': instance.TenMon,
      'SoTinChi': instance.SoTinChi,
      'CC': instance.CC,
      'KT': instance.KT,
      'THI': instance.THI,
      'TKHP': instance.TKHP,
      'DiemChu': instance.DiemChu,
    };
