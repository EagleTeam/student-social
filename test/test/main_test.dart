import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studentsocial/main.dart';

void main() {
  testWidgets('Đảm bảo main app hoạt động bình thường',
      (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));
  });
}
