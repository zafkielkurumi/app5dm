import 'package:app5dm/models/videoItemsModel.dart';
import './api.dart';
import 'package:app5dm/utils/index.dart';

class SearchApi {
  static Future<List<Seasons>> search(String keyword, int page) async {
   
    var url = '${Api.search}/$keyword/page/2';
    var res = await NetUtil.dio.get('${Api.homePage}/video/bangumi');
    return transformSearch('res'.toString());
  }


}

