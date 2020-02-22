
import 'package:app5dm/utils/index.dart';

class VideoDetailApi {
  static Future getVideoDetail(String link) async {
     var res = await NetUtil.dio.get(link);
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

