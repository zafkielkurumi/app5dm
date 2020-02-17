import 'net.dart';
import 'package:app5dm/models/timelime_model.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
Future<String> transferIframe({String iframeUrl}) async {
  var res = await NetUtil.dio.get(iframeUrl);
  RegExp regExp = RegExp(r'srcUrl={.*(https://api.5dm.tv.*\.mp4)');
  RegExpMatch match = regExp.firstMatch(res.toString());
  print(match.group(0));
  print(match.group(1));
  return match.group(1);
}




List<Timeline> tranferTimeline(String html) {
  // var exg = new RegExp(r'matrix3d\d');
  //  String str = 'matrix3d3(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4)matrix3d4';
  //  print(exg.allMatches(str).toList()[0].group(0));
  //  print(exg.allMatches(str).toList()[1].group(0));
  // RegExp timeline = new RegExp(r'');
  Document document = parse(html);
  Element wpbWrappper = document.querySelector('.wpb_wrapper');
  // smartboxs 周日到周一
  List<Element> smartBoxs = wpbWrappper.querySelectorAll('.smart-box');
  List<Timeline> timeline = [];
  for (var smartBox in smartBoxs) {
     List<Element> videoItems = smartBox.querySelectorAll('.video-item');
    if (videoItems.isEmpty) {
      continue;
    }
    String title = smartBox.querySelector('.smart-box-head').text?.substring(1);
    
    List<Seasons> seasons = [];
    // 获取个番剧item
    videoItems.forEach((videoItem) {
      String imgUrl = videoItem.querySelector('img').attributes['data-original'];
      imgUrl = imgUrl.startsWith('https://www.5dm.tv')
          ? imgUrl
          : 'https://www.5dm.tv$imgUrl';
      String stringId = videoItem.querySelector('h3 a').attributes['href'];
      stringId = stringId;
      seasons.add(Seasons(
          imgUrl: imgUrl,
          stringId: stringId,
          title: videoItem.querySelector('h3 a').innerHtml));
    });
    timeline.add(Timeline(title: title, seasons: seasons));
  }

  return timeline;
}

List<Timeline> transferHomePage(String html) {
  return tranferTimeline(html);
}