import 'dart:convert';

import 'package:dio/dio.dart';

import 'netHelper.dart';
import 'package:app5dm/models/index.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:app5dm/constants/config.dart';

Future<String> transformIframe({String iframeUrl}) async {
  print(BASE_URL + iframeUrl);
  var res = await NetUtil.dio.get(BASE_URL + iframeUrl,
      options: Options(headers: {'referer': 'https://www.5dm.app'}));
  RegExp regExp = RegExp(r'https://www.5dm.app.*\.mp4');
  // RegExpMatch match = regExp.firstMatch(res.toString());
  Document document = parse(res.toString());
  List<Element> scriptList = document.querySelectorAll('script');
  Element script = scriptList.last;
  print(script.text);
  String text = script.text.replaceAll("'", '"');
  RegExp regConfig = RegExp(r'config\s*=\s*({[\s | \S]*})');
  RegExpMatch match = regConfig.firstMatch(text);
  print(match[1]);
  Map config = jsonDecode(match[1]);
    print('-===========');
   print(config);
  return config['url'];
}

// 时间表
List<VideoItems> tranferVideoItem(String html) {
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
    // imgUrl = imgUrl.startsWith('$BASE_URL') ? imgUrl : '$BASE_URL$imgUrl';
    imgUrl = imgUrl;

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
  String videoTitle = document.querySelector('h1.video-title')?.text;
  String brief = document.querySelector('.video-conent .item-content p')?.text;
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
      links.add(Links(title: aLink.text, url: aLink.attributes['href']));
    });
    sources.add(Sources(links: links, sourceTitle: sourceTitle));
  });
  return VideoDetail(
      sources: sources, videoSrc: videoSrc, title: videoTitle, brief: brief);
}

bool checkIsLogin(String html) {
  Document document = parse(html);
  Element awsl = document.getElementById('awsl');
  if (awsl != null && awsl.innerHtml.isNotEmpty) {
    return true;
  }
  return false;
}

        //  var up = {
        //      "usernum": "",
        //      "mylink": "/bgm/",
        //      "diyid": [0, '游客', 1]
        //  }
        //  var config = {
        //      "api": '/player/',
        //      "av": '',
        //      "url": "https://dv.5dm.app/5/banyaodeycs1.mp4?query_string=should_be_calcuated&_tcshare=031cbc72717d4e7435f4d1b",
        //      "id": "banyaodeycs1",
        //      "sid": "",
        //      "pic": "",
        //      "title": "",
        //      "next": "dv46141?link=1",
        //      "user": '0',
        //      "group": ""
        //  }
        //  YZM.start()
