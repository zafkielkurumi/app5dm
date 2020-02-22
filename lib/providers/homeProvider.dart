import 'package:app5dm/models/index.dart';
import 'package:flutter/foundation.dart';

import './baseProvider.dart';
import 'package:app5dm/apis/homeApi.dart';


class HomeModel extends BaseProvider {
  HomeModel() {
    loadData();
  }

  List<VideoItems> homelines = [];

  loadData() async {
    try {
       homelines = await HomeApi.getHomePage();
       setContent();
    } catch (e) {
      
      onError(e);
      debugPrint(e.toString());
    }

 }
@override
retry() {
  setFirst();
  loadData();
}
Future refresh() async {
   await loadData();
 }
}