// this class must be initialize before runApp method
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio _dio;

  static init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        // const url for the app
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // get data
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String token = '',
  }) async {
    // set headers here
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await _dio.get(url, queryParameters: query);
  }

  // post data
  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String token = '',
  }) async {
    // set headers here
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await _dio.post(url, data: data, queryParameters: query);
  }

  // post data
  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String token = '',
  }) async {
    // set headers here
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await _dio.put(url, data: data, queryParameters: query);
  }
}
