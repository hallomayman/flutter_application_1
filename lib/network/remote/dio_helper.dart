import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
          ),
    );
  }

  static Future<Response> getData(
      {required String url, query, lang = 'en', authorization}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': authorization ?? '',
    };
    return await dio.get(url, queryParameters: query ?? null);
  }

  static Future<Response> postData(
      {required String url,
      query,
      required Map<String, dynamic> data,
      lang = 'en',
      authorization}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': authorization ?? '',
    };
    return dio.post(
      url,
      queryParameters: query ?? null,
      data: data,
    );
  }


  static Future<Response> putData(
      {required String url,
        query,
        required Map<String, dynamic> data,
        lang = 'en',
        authorization}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': authorization ?? '',
    };
    return dio.put(
      url,
      queryParameters: query ?? null,
      data: data,
    );
  }
}
