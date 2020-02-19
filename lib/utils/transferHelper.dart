import 'net.dart';
import 'package:app5dm/models/index.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:app5dm/constants/config.dart';
Future<String> transferIframe({String iframeUrl}) async {
  var res = await NetUtil.dio.get(iframeUrl);
  RegExp regExp = RegExp(r'srcUrl={.*(https://api.5dm.tv.*\.mp4)');
  RegExpMatch match = regExp.firstMatch(res.toString());
  return match.group(1);
}




List<VideoItems> tranferVideoItem(String html) {
  // var exg = new RegExp(r'matrix3d\d');
  //  String str = 'matrix3d3(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4)matrix3d4';
  //  print(exg.allMatches(str).toList()[0].group(0));
  //  print(exg.allMatches(str).toList()[1].group(0));
  // RegExp timeline = new RegExp(r'');
  Document document = parse(html);
  Element wpbWrappper = document.querySelector('.wpb_wrapper');
  // smartboxs 周日到周一
  List<Element> smartBoxs = wpbWrappper.querySelectorAll('.smart-box');
  List<VideoItems> timeline = [];
  for (var smartBox in smartBoxs) {
     List<Element> videoItems = smartBox.querySelectorAll('.video-item');
    if (videoItems.isEmpty) {
      continue;
    }
    String title = smartBox.querySelector('.smart-box-head h2.light-title').text;
    String more = smartBox.querySelector('.smart-box-head a:last-child')?.attributes['href'];
    more = more.startsWith(BASE_URL)  ? more : '$BASE_URL$more';
    if (more.startsWith('#')) {
      more = '';
    } else {
      more =  more.startsWith(BASE_URL)  ? more : '$BASE_URL$more';
    }
    
    List<Seasons> seasons = [];
    // 获取个番剧item
    videoItems.forEach((videoItem) {
      String imgUrl = videoItem.querySelector('img').attributes['data-original'];
      imgUrl = imgUrl.startsWith('$BASE_URL')
          ? imgUrl
          : '$BASE_URL$imgUrl';
      String stringId = videoItem.querySelector('h3 a').attributes['href'];
      stringId = stringId;
      seasons.add(Seasons(
          imgUrl: imgUrl,
          stringId: stringId,
          title: videoItem.querySelector('h3 a').innerHtml));
    });
    timeline.add(VideoItems(title: title, seasons: seasons, more: more));
  }

  return timeline;
}

List<VideoItems> transferHomePage(String html) {
  return tranferVideoItem(html);
}

double tranferImageWidthToHeiht(double width) {
  // width 520 height 293
  // height/width = heigth1/width1
  return width * 293 / 520;
}

transferSearch(String html) {
    Document document = parse(html);
     List<Element> videoItems = document.querySelectorAll('.video-item');
     List<Seasons> seasons = [];
    // 获取个番剧item
    for (var videoItem in videoItems) {
       String stringId = videoItem.querySelector('h3 a').attributes['href'];
       if (!stringId.contains(RegExp(r'tv/[end | bangumi | ova]'))) {
         continue;
       }
       String imgUrl = videoItem.querySelector('img').attributes['data-original'];
      imgUrl = imgUrl.startsWith('$BASE_URL')
          ? imgUrl
          : '$BASE_URL$imgUrl';
     
      stringId = stringId;
      seasons.add(Seasons(
          imgUrl: imgUrl,
          stringId: stringId,
          title: videoItem.querySelector('h3 a').innerHtml));
    }
}