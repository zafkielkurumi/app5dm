import 'package:app5dm/models/index.dart';

import './baseProvider.dart';
import 'package:app5dm/apis/homeApi.dart';


class TimelineModel extends BaseProvider {
  TimelineModel() {
    loadData();
  }

  List<VideoItems> timelines = [];

  loadData() async {
    try {
       timelines = await HomeApi.getTimeline();
       setContent();
    } catch (e) {
      onError(e);
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