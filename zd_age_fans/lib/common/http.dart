import 'package:dio/dio.dart';
import 'constant.dart';

class HttpClient {
  static final dio = Dio(BaseOptions(baseUrl: baseUrl));

  static int() {}

  static Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final resp = await dio.get(url, queryParameters: queryParameters);
    return resp;
  }

  static Future<Response> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? formData,
    Options? options,
  }) async {
    final resp = await dio.post(url,
        queryParameters: queryParameters,
        data: formData != null ? FormData.fromMap(formData) : null,
        options: options);
    return resp;
  }
}
