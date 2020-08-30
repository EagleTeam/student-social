import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'config/strings.dart';
import 'presentation/screens/main/main.dart';
import 'presentation/screens/main/main_notifier.dart';
import 'services/http/rest_client.dart';
import 'services/local_storage/database/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Register your license here
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgnMT5qa303NiUTND4yOj99MDw+');
  runApp(MultiProvider(providers: [
    Provider<MyDatabase>(
      create: (_) => MyDatabase.instance,
      lazy: false,
      // Đặt là lazy false thì nó sẽ được khởi tạo luôn, nếu không thì
      // đến khi dùng nó mới khởi tạo, mà database sẽ tốn 1 khoảng thời
      // gian nhất định để khởi tạo nên sẽ khởi tạo nó luôn từ đầu chánh
      // tới lúc dùng lại phải đợi :D
    ),
    Provider<RestClient>(
      create: (_) => RestClient.create(),
    ),
    ChangeNotifierProvider<MainNotifier>(
      create: (BuildContext ct) =>
          MainNotifier(Provider.of<MyDatabase>(ct, listen: false)),
    )
  ], child: MyApp()));
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
