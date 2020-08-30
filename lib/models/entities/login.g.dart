// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResult _$MessageResultFromJson(Map<String, dynamic> json) {
  return MessageResult(
    Token: json['Token'] as String,
    profile: json['Profile'] == null
        ? null
        : Profile.fromJson(json['Profile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MessageResultToJson(MessageResult instance) =>
    <String, dynamic>{
      'Token': instance.Token,
      'Profile': instance.profile,
    };

LoginSuccess _$LoginSuccessFromJson(Map<String, dynamic> json) {
  return LoginSuccess(
    status: json['status'] as String,
    message: json['message'] == null
        ? null
        : MessageResult.fromJson(json['message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginSuccessToJson(LoginSuccess instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

LoginFail _$LoginFailFromJson(Map<String, dynamic> json) {
  return LoginFail(
    status: json['status'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$LoginFailToJson(LoginFail instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
