import 'package:flutter_test/flutter_test.dart';
import 'package:studentsocial/models/entities/login.dart';
import 'package:studentsocial/services/http/rest_client.dart';

void main() {
  test('test api', () async {
    final RestClient client = RestClient.create();
    final LoginResult loginResult =
        await client.login('DTC16HD4802010001', ';');
    expect(loginResult.isSuccess(), false);
  });
}
