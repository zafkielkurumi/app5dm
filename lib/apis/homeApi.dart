import 'package:app5dm/models/timelime_model.dart';
import './api.dart';
import 'package:app5dm/utils/index.dart';

class HomeApi {
  static Future<List<Timeline>> getTimeTime() async {
    var res = await NetUtil.dio.get(Api.timeLine);
    return tranferTimeline(res.toString());
  }
}

