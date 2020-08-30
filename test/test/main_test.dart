import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:studentsocial/main.dart';
import 'package:studentsocial/presentation/screens/main/main_notifier.dart';
import 'package:studentsocial/services/http/rest_client.dart';
import 'package:studentsocial/services/local_storage/database/database.dart';

void main() {
  testWidgets('Đảm bảo main app hoạt động bình thường',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
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
  });
}
