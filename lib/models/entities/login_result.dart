// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

class LoginResult {
  LoginResult(this.user, this.headers);
  User user;

  Map<String, String> headers;
}
