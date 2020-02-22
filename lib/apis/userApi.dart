import 'package:app5dm/utils/index.dart';
import 'package:dio/dio.dart';

import './api.dart';

class UserApi {
  static Future<bool> login({String userName, String pwd}) async {
    Map<String, dynamic> params = {
      "log": userName,
      "pwd": pwd,
      "rememberme": "forever",
      "testcookie": 1,
      "redirect_to": "https://www.5dm.tv/wp-admin/"
    };
    print(params);
    var res = await NetUtil.dio.request(Api.login, options: Options(method: 'post', followRedirects: true), data: FormData.fromMap(params));
    print(res.toString());
    print('res.toString()');
    return checkIsLogin(res.toString());
  }

  static regresit() {}
}

bool checkIsLogin(String html) {
  return html.contains('退出登录');
}
