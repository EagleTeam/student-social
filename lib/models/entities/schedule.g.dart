// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return Schedule(
    ID: json['ID'] as int,
    MaSinhVien: json['MaSinhVien'] as String,
    MaMon: json['MaMon'] as String,
    HocPhan: json['HocPhan'] as String,
    ThoiGian: json['ThoiGian'] as String,
    Ngay: json['Ngay'] as String,
    TietHoc: json['TietHoc'] as String,
    DiaDiem: json['DiaDiem'] as String,
    HinhThuc: json['HinhThuc'] as String,
    GiaoVien: json['GiaoVien'] as String,
    LoaiLich: json['LoaiLich'] as String,
    SoBaoDanh: json['SoBaoDanh'] as String,
    SoTinChi: json['SoTinChi'] as String,
  );
}

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'ID': instance.ID,
      'MaSinhVien': instance.MaSinhVien,
      'MaMon': instance.MaMon,
      'HocPhan': instance.HocPhan,
      'ThoiGian': instance.ThoiGian,
      'TietHoc': instance.TietHoc,
      'Ngay': instance.Ngay,
      'DiaDiem': instance.DiaDiem,
      'HinhThuc': instance.HinhThuc,
      'GiaoVien': instance.GiaoVien,
      'LoaiLich': instance.LoaiLich,
      'SoBaoDanh': instance.SoBaoDanh,
      'SoTinChi': instance.SoTinChi,
    };

ScheduleMessage _$ScheduleMessageFromJson(Map<String, dynamic> json) {
  return ScheduleMessage(
    Entries: (json['Entries'] as List)
        ?.map((e) =>
            e == null ? null : Schedule.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ScheduleMessageToJson(ScheduleMessage instance) =>
    <String, dynamic>{
      'Entries': instance.Entries,
    };

ScheduleSuccess _$ScheduleSuccessFromJson(Map<String, dynamic> json) {
  return ScheduleSuccess(
    status: json['status'] as String,
    message: json['message'] == null
        ? null
        : ScheduleMessage.fromJson(json['message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ScheduleSuccessToJson(ScheduleSuccess instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

ScheduleFail _$ScheduleFailFromJson(Map<String, dynamic> json) {
  return ScheduleFail(
    status: json['status'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$ScheduleFailToJson(ScheduleFail instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
