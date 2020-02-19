import 'package:app5dm/models/videoItemsModel.dart';
import './api.dart';
import 'package:app5dm/utils/index.dart';

class SearchApi {
  static Future<List<VideoItems>> search(String keyword, int page) async {
    var res = await NetUtil.dio.get(Api.search);
    return transferSearch(res.toString());
  }
}

