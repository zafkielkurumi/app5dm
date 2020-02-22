import 'package:app5dm/apis/userApi.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import './baseProvider.dart';

class UserModel extends BaseProvider {
  Future<bool> login({String userName, String pwd}) async {
    setPending();
    try {
      var res = await UserApi.login(pwd: pwd, userName: userName);
      if (res) {
        setContent();
        return true;
      } else {
        setContent();
        showToast('用户名或密码错误', position: ToastPosition.top);
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 302) {
          return true;
        }
      }
      setError();
    }
    return false;
  }
}
