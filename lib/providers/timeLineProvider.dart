import 'package:app5dm/models/timelime_model.dart';

import './baseProvider.dart';
import 'package:app5dm/apis/homeApi.dart';


class TimelineModel extends BaseProvider {
  TimelineModel() {
    loadData();
  }

  List<Timeline> timelines = [];

  loadData() async {
    try {
       timelines = await HomeApi.getTimeTime();
       setContent();
    } catch (e) {
      onError();
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