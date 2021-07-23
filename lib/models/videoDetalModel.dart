import 'dart:convert' show json;
import './protect.dart';

class VideoDetail {
  String title;
  String brief;
  String videoSrc;
  List<Sources> sources;

  VideoDetail({
    this.title,
    this.brief,
    this.videoSrc,
    this.sources,
  });

  factory VideoDetail.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Sources> sources = jsonRes['sources'] is List ? [] : null;
    if (sources != null) {
      for (var item in jsonRes['sources']) {
        if (item != null) {
          tryCatch(() {
            sources.add(Sources.fromJson(item));
          });
        }
      }
    }
    return VideoDetail(
      title: convertValueByType(jsonRes['title'], String,
          stack: "VideoDetail-title"),
      brief: convertValueByType(jsonRes['brief'], String,
          stack: "VideoDetail-brief"),
      videoSrc: convertValueByType(jsonRes['videoSrc'], String,
          stack: "VideoDetail-videoSrc"),
      sources: sources,
    );
  }

  Map<String, dynamic> toJson() => {
        'videoTitle': title,
        'brief': brief,
        'videoSrc': videoSrc,
        'sources': sources,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Sources {
  String sourceTitle;
  List<Links> links;

  Sources({
    this.sourceTitle,
    this.links,
  });

  factory Sources.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Links> links = jsonRes['links'] is List ? [] : null;
    if (links != null) {
      for (var item in jsonRes['links']) {
        if (item != null) {
          tryCatch(() {
            links.add(Links.fromJson(item));
          });
        }
      }
    }
    return Sources(
      sourceTitle: convertValueByType(jsonRes['sourceTitle'], String,
          stack: "Sources-sourceTitle"),
      links: links,
    );
  }

  Map<String, dynamic> toJson() => {
        'sourceTitle': sourceTitle,
        'links': links,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Links {
  String title;
  String url;

  Links({
    this.title,
    this.url,
  });

  factory Links.fromJson(jsonRes) => jsonRes == null
      ? null
      : Links(
          title: convertValueByType(jsonRes['title'], String,
              stack: "Links-title"),
          url:
              convertValueByType(jsonRes['link'], String, stack: "Links-url"),
        );

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': url,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

// {
//  "title": "33",
// "brief":"55",
// "video_src": "fff",
// "sources":[
//  {
//  "sourceTitle":"44",
// "links": [
//  {
//  "title":"4",
// "uel":"55"
// }
// ]
// }
// ]
// }
