import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';


class NetUtil {
  static final Dio dio = new Dio(BaseOptions(
    // baseUrl: kReleaseMode ? '' : '',
    // baseUrl: "https://www.5dm.tv/",
    connectTimeout: 15000,
    receiveTimeout: 15000,
    headers: {
     "User-Agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Mobile Safari/537.36"}
  ));
  static CookieJar cookieJar = new CookieJar();

  static void init() {
    dio.interceptors
      ..add(CookieManager(cookieJar))
      ..add((InterceptorsWrapper(onRequest: (RequestOptions options) async {
         debugPrint('net start');
        return options;
      }, onResponse: (Response response) async {
        debugPrint('net end');
        return response;
      }, onError: (DioError e) async {
        // if (e i)
        if (e.type  == DioErrorType.RESPONSE && e.response.statusCode == 503) {
          showToast('503');
        }
        if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
          showToast('网络连接超时');
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
        debugPrint('start');
        return options;
      }, onResponse: (Response response) async {
        return response;
      }, onError: (DioError e) async {
        debugPrint("dioError: ${e.message}");
        return e;
      })));
  }
}
