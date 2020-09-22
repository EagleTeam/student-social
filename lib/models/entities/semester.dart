// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'semester.g.dart';

@JsonSerializable()
class Semester {
  final String TenKy;
  final String MaKy;
  final bool IsNow;

  Semester({this.TenKy, this.MaKy, this.IsNow});

  factory Semester.fromJson(Map<String, dynamic> json) =>
      _$SemesterFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterToJson(this);

  factory Semester.fromString(String value) =>
      Semester.fromJson(jsonDecode(value));
}

@JsonSerializable()
class SemesterResult {
  String status;
  List<Semester> message;

  SemesterResult({this.status, this.message});

  factory SemesterResult.fromJson(Map<String, dynamic> json) =>
      _$SemesterResultFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterResultToJson(this);
}
