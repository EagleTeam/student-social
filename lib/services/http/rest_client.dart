import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../config/url.dart';
import '../../models/entities/login.dart';
import '../../models/entities/schedule.dart';
import '../../models/entities/semester.dart';

part 'rest_client.g.dart';

final restClient = RestClient.create();

@RestApi(baseUrl: URL.server)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  factory RestClient.create() {
    final dio = Dio();
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestHeader: false,
        requestBody: true,
        request: false));

    return RestClient(dio);
  }

  @POST(URL.login)
  Future<LoginResult> login(@Field() String username, @Field() String password);

  @POST(URL.semester)
  Future<SemesterResult> getSemester(@Header('token') String token);

//  Future<String> getProfile(String token) async {
//    var res =
//        await http.post(URL.GET_PROFILE, headers: {"access-token": token});
//    if (res.statusCode == 200) {
//      return res.body;
//    } else {
//      return '';
//    }
//  }

//  Future<String> getMark(String token) async {
//    var res = await http.post(URL.GET_MARK, headers: {"access-token": token});
//    if (res.statusCode == 200) {
//      return res.body;
//    } else {
//      return '';
//    }
//  }

  @POST(URL.timeTable)
  Future<ScheduleResult> getLichHoc(
      @Header('token') String token, @Field() String semester);

  //hàm này dùng cho cả get lichthilai vì đều là lịch thi (chỉ khác semester)
  @POST(URL.examTable)
  Future<ScheduleResult> getLichThi(
      @Header('token') String token, @Field() String semester);
}
