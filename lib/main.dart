import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'config/strings.dart';
import 'presentation/screens/main/main.dart';
import 'presentation/screens/main/main_notifier.dart';
import 'services/local_storage/database/database.dart';

final databaseProvider = Provider<MyDatabase>((ref) {
  return MyDatabase.instance;
});
final mainProvider = ChangeNotifierProvider<MainNotifier>((ref) {
  return MainNotifier(ref.watch(databaseProvider));
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Register your license here
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgnMT5qa303NiUTND4yOj99MDw+');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // Create the initilization Future outside of `build`:
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
            return Material(
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Oops!\n Something went wrong.'),
                ),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MainScreen();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Material(
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text('Loading Firebase ...'),
              ),
            ),
          );
        },
      ),
    );
  }
}
