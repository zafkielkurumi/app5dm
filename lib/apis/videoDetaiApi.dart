
import 'package:app5dm/utils/index.dart';
import 'package:dio/dio.dart';

class VideoDetailApi {
  static CancelToken _cancelToken = CancelToken();
  static Future getVideoDetail(String link) async {
     var res = await NetUtil.dio.get(link, cancelToken: _cancelToken);
     String html = res.toString();
     if (checkIsLogin(html)) {
       return;
     }
     return await tranferDetail(html);
  }
}

bool checkIsLogin(String html) {
  // Document document = parse(html);
  return html.contains('前往登陆');
}

