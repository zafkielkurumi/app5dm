import 'netHelper.dart';
import 'package:app5dm/models/index.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:app5dm/constants/config.dart';

import 'package:flutter/services.dart';
// import 'package:flutter_liquidcore/liquidcore.dart';

Future<String> transformIframe({String iframeUrl}) async {
  var res = await NetUtil.dio.get(iframeUrl);
  RegExp regExp = RegExp(r'srcUrl={.*(https://api.5dm.tv.*\.mp4)');
  RegExpMatch match = regExp.firstMatch(res.toString());
  return match.group(1);
}

// 时间表
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
    String title =
        smartBox.querySelector('.smart-box-head h2.light-title').text;
    String more = smartBox
        .querySelector('.smart-box-head a:last-child')
        ?.attributes['href'];
    if (more.startsWith('#')) {
      more = '';
    } else {
      more = more.startsWith(BASE_URL) ? more : '$BASE_URL$more';
    }

    List<Seasons> seasons = transformSeasons(videoItems);
    timeline.add(VideoItems(title: title, seasons: seasons, more: more));
  }

  return timeline;
}

// 首页
List<VideoItems> transformHomePage(String html) {
  return tranferVideoItem(html);
}

double tranferImageWidthToHeiht(double width) {
  // width 520 height 293
  // height/width = heigth1/width1
  if (width is num) {
    return width * 293 / 520;
  }
  return null;
}

List<Seasons> transformSeasons(List<Element> videoItems) {
  List<Seasons> seasons = [];
  // 获取个番剧item
  for (var videoItem in videoItems) {
    String stringId = videoItem.querySelector('h3 a').attributes['href'];
    //  if (!stringId.contains(RegExp(r'tv/[end | bangumi | ova]'))) {
    //    continue;
    //  }
    String imgUrl = videoItem.querySelector('img').attributes['data-original'];
    imgUrl = imgUrl.startsWith('$BASE_URL') ? imgUrl : '$BASE_URL$imgUrl';

    stringId = stringId;
    seasons.add(Seasons(
        imgUrl: imgUrl,
        stringId: stringId,
        title: videoItem.querySelector('h3 a').innerHtml));
  }
  return seasons;
}

List<Seasons> transformSearch(String html) {
  Document document = parse(html);
  List<Element> videoItems = document.querySelectorAll('.video-item');
  return transformSeasons(videoItems);
}

List<Seasons> transformSerial(String html) {
  Document document = parse(html);
  List<Element> videoItems = document.querySelectorAll('.video-item');
  return transformSeasons(videoItems);
}

tranferForbiden(String html) async {
  Document document = parse(html);
  Element script = document.querySelector('script');
  print(script.innerHtml.contains('challenge-form'));
  // JSContext _jsContext = new JSContext();
  // var a = await _jsContext.evaluateScript(
  //     "eval('+((!+[]+!![]+!![]+!![]+!![]+!![]+!![]+!![]+[])+(!+[]+!![]+!![])+(!+[]+!![]+!![]+!![]+!![]+!![]+!![]+!![])+(+[])+(!+[]+!![]+!![]+!![])+(+!![])+(!+[]+!![]+!![]+!![]+!![]+!![])+(!+[]+!![]+!![]+!![])+(+!![]))/+((!+[]+!![]+!![]+!![]+!![]+!![]+!![]+[])+(!+[]+!![])+(!+[]+!![]+!![])+(+!![])+(+!![])+(!+[]+!![])+(!+[]+!![]+!![])+(!+[]+!![]+!![]+!![]+!![]+!![])+(!+[]+!![]+!![]+!![]+!![]+!![]+!![]+!![]))')");
  // if (_jsContext != null) {
  //   _jsContext.cleanUp();
  // }
  var base = 'www.5dm.com'; // len
}


Future<VideoDetail> tranferDetail(String html) async {
  Document document = parse(html);
  String videoTitle = document.querySelector('h1.video-title').text;
  //处理ifram
  Element iframe = document.querySelector('iframe');
  String videoSrc = iframe != null
      ? await transformIframe(iframeUrl: iframe.attributes['src'])
      : '';
  List<Element> trs = document.querySelectorAll('.multilink-table-wrap tr');
  List<Sources> sources = [];
  trs.forEach((tr) {
    String sourceTitle = tr.querySelector('.multilink-title').text;
    List<Element> aLinks = tr.querySelectorAll('a');
    List<Links> links = [];
    aLinks.forEach((aLink) {
      links.add(Links(title: aLink.text, link: aLink.attributes['href']));
    });
    sources.add(Sources(links: links, sourceTitle: sourceTitle));
  });
  return VideoDetail(
      sources: sources, videoSrc: videoSrc, videoTitle: videoTitle);
}


