import 'package:firebase_auth/firebase_auth.dart';

class LoginResult {
  LoginResult(this.firebaseUser, this.headers);
  FirebaseUser firebaseUser;

  Map<String, String> headers;
}
