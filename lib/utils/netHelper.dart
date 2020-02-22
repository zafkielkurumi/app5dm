import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';

class NetUtil {
  static final Dio dio = new Dio(BaseOptions(
    // baseUrl: "https://www.5dm.tv/",
    connectTimeout: 10000,
    receiveTimeout: 10000,
    followRedirects: true
  ));
  static CookieJar cookieJar = new CookieJar();

  static void init() {
    dio.interceptors
      ..add(CookieManager(cookieJar))
      ..add((InterceptorsWrapper(onRequest: (RequestOptions options) async {
        print(options.path);
         debugPrint('net start');
        return options;
      }, onResponse: (Response response) async {
        debugPrint('net end');
        return response;
      }, onError: (DioError e) async {
        if (e.response.statusCode == 503) {
          showToast('503');
        }
        debugPrint("dioError: ${e.message}");
        return e;
      })));
  }
}

class BaseHttp extends DioForNative {
  static CookieJar cookieJar = new CookieJar();

  BaseHttp([BaseOptions options]) : super(options) {
    interceptors
      ..add(CookieManager(cookieJar))
      ..add((InterceptorsWrapper(onRequest: (RequestOptions options) async {
        print('start');
        return options;
      }, onResponse: (Response response) async {
        return response;
      }, onError: (DioError e) async {
        debugPrint("dioError: ${e.message}");
        return e;
      })));
  }
}