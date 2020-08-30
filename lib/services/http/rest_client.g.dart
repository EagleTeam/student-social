// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://buknhanh.com/api/student/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  login(username, password) async {
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'username': username, 'password': password};
    final Response<Map<String, dynamic>> _result = await _dio.request('login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = LoginResult.fromJson(_result.data);
    return value;
  }

  @override
  getSemester(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'semester',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'token': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = SemesterResult.fromJson(_result.data);
    return value;
  }

  @override
  getLichHoc(token, semester) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(semester, 'semester');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'semester': semester};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'time-table',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'token': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ScheduleResult.fromJson(_result.data);
    return value;
  }

  @override
  getLichThi(token, semester) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(semester, 'semester');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'semester': semester};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'exam-table',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'token': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ScheduleResult.fromJson(_result.data);
    return value;
  }
}
