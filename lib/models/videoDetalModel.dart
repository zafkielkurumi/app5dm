import 'dart:convert' show json;
import './protect.dart';

class VideoDetail {
  String videoTitle;
  String brief;
  String videoSrc;
  List<Sources> sources;

  VideoDetail({
    this.videoTitle,
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
      videoTitle: convertValueByType(jsonRes['videoTitle'], String,
          stack: "VideoDetail-videoTitle"),
      brief: convertValueByType(jsonRes['brief'], String,
          stack: "VideoDetail-brief"),
      videoSrc: convertValueByType(jsonRes['videoSrc'], String,
          stack: "VideoDetail-videoSrc"),
      sources: sources,
    );
  }

  Map<String, dynamic> toJson() => {
        'videoTitle': videoTitle,
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
  String link;

  Links({
    this.title,
    this.link,
  });

  factory Links.fromJson(jsonRes) => jsonRes == null
      ? null
      : Links(
          title: convertValueByType(jsonRes['title'], String,
              stack: "Links-title"),
          link:
              convertValueByType(jsonRes['link'], String, stack: "Links-link"),
        );

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

// {
//  "videoTitle": "33",
// "brief":"55",
// "videoSrc": "fff",
// "sources":[
//  {
//  "sourceTitle":"44",
// "links": [
//  {
//  "title":"4",
// "link":"55"
// }
// ]
// }
// ]
// }
