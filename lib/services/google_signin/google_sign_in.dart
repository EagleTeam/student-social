// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

// Project imports:
import '../../models/entities/login_result.dart';

class GoogleSignInHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'profile',
    'email',
    CalendarApi.CalendarEventsScope,
    CalendarApi.CalendarScope
  ]);

  Future<LoginResult> signInWithGoogle() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);

    final user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null, 'email must not be null');
    assert(user.displayName != null, 'displayName must not be null');
    assert(user.photoURL != null, 'photoUrl must not be null');

    assert(!user.isAnonymous, 'user must not be anonymous');
    assert(await user.getIdToken() != null, 'token must not be null');

    final currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid, 'uid must be match');

    final headers = await googleSignInAccount.authHeaders;
    return LoginResult(user, headers);
  }

  Future<GoogleSignInAccount> signOutGoogle() async {
    return await googleSignIn.signOut();
  }
}
