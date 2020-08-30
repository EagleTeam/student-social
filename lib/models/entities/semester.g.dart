// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Semester _$SemesterFromJson(Map<String, dynamic> json) {
  return Semester(
    TenKy: json['TenKy'] as String,
    MaKy: json['MaKy'] as String,
    IsNow: json['IsNow'] as bool,
  );
}

Map<String, dynamic> _$SemesterToJson(Semester instance) => <String, dynamic>{
      'TenKy': instance.TenKy,
      'MaKy': instance.MaKy,
      'IsNow': instance.IsNow,
    };

SemesterResult _$SemesterResultFromJson(Map<String, dynamic> json) {
  return SemesterResult(
    status: json['status'] as String,
    message: (json['message'] as List)
        ?.map((e) =>
            e == null ? null : Semester.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SemesterResultToJson(SemesterResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
