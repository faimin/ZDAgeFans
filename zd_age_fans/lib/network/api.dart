import 'package:dio/dio.dart';

class API {
  static final Dio dio = Dio(BaseOptions(baseUrl: "https://app.age-api.com:8443"));

}