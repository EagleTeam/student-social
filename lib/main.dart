// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/core.dart';

// Project imports:
import 'config/strings.dart';
import 'presentation/screens/main/main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register your license here
  // Note: this is my license key for open source
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgnMT5qa303NiUTND4yOj99MDw+');
  runApp(ProviderScope(child: MyApp()));
}

// ignore: public_member_api_docs
class MyApp extends StatelessWidget {
  // ignore: public_member_api_docs
  MyApp({Key key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      locale: const Locale('vi'),
      title: Strings.titleApp,
      theme: ThemeData(primaryColor: Colors.green),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return _FirebaseLoading(
                'Oops!\nSomething went wrong.\n${snapshot.error.toString()}');
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return const MainScreen();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return const _FirebaseLoading('Loading Firebase ...');
        },
      ),
    );
  }
}

class _FirebaseLoading extends StatelessWidget {
  const _FirebaseLoading(this.title);

  /// title for firebase loading
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}
