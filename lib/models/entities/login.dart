// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'profile.dart';

part 'login.g.dart';

@JsonSerializable()
class MessageResult {
  MessageResult({this.Token, this.profile});
  factory MessageResult.fromJson(Map<String, dynamic> json) =>
      _$MessageResultFromJson(json);

  String Token;
  @JsonKey(name: 'Profile')
  Profile profile;

  Map<String, dynamic> toJson() => _$MessageResultToJson(this);
}

@JsonSerializable()
class LoginSuccess implements LoginResult {
  LoginSuccess({this.status, this.message});
  factory LoginSuccess.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessFromJson(json);

  String status;

  MessageResult message;

  @override
  bool isSuccess() {
    return status == 'success';
  }

  Map<String, dynamic> toJson() => _$LoginSuccessToJson(this);
}

@JsonSerializable()
class LoginFail implements LoginResult {
  LoginFail({this.status, this.message});
  factory LoginFail.fromJson(Map<String, dynamic> json) =>
      _$LoginFailFromJson(json);

  String status;

  String message;

  @override
  bool isSuccess() {
    return status == 'success';
  }

  Map<String, dynamic> toJson() => _$LoginFailToJson(this);
}

abstract class LoginResult {
  factory LoginResult.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'success') {
      return LoginSuccess.fromJson(json);
    } else {
      return LoginFail.fromJson(json);
    }
  }

  bool isSuccess();
}
