

import 'package:app5dm/models/index.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:app5dm/utils/index.dart';

class VideoDetailApi {
  static Future<VideoDetail> getVideoDetail(String link) async {
     var res = await NetUtil.dio.get(link);
     return await tranferDetail(res.toString());
  }
}

Future<VideoDetail> tranferDetail(String html) async {
 Document document = parse(html);
 String videoTitle = document.querySelector('h1.video-title').text;
 //处理ifram
 Element iframe = document.querySelector('iframe');
 print(iframe.attributes['src']);
 String videoSrc = await  transferIframe(iframeUrl: iframe.attributes['src']);
 List<Element> trs = document.querySelectorAll('.multilink-table-wrap tr');
 List<Sources> sources = [];
 trs.forEach((tr) {
   String sourceTitle = tr.querySelector('.multilink-title').text;
   List<Element> aLinks = tr.querySelectorAll('a');
   List<Links> links = [];
   aLinks.forEach((aLink) {
     links.add(Links(
       title: aLink.text,
       link: aLink.attributes['href']
     ));
   }); 
   sources.add(Sources(links: links, sourceTitle: sourceTitle));
 });
 return VideoDetail(sources: sources, videoSrc: videoSrc, videoTitle: videoTitle);
}