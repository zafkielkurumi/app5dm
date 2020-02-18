import 'package:app5dm/models/videoItemsModel.dart';
import './api.dart';
import 'package:app5dm/utils/index.dart';

class HomeApi {
  static Future<List<VideoItems>> getTimeline() async {
    var res = await NetUtil.dio.get(Api.timeLine);
    return tranferVideoItem(res.toString());
  }

  static Future<List<VideoItems>> getHomePage() async {
    var res = await NetUtil.dio.get(Api.homePage);
    return transferHomePage(res.toString());
  } 
}

