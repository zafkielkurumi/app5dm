import 'dart:convert' show json;
import './protect.dart';

class VideoDetail {
  List<Sources> sources;
  String videoSrc;
  String videoTitle;

  VideoDetail({
    this.sources,
    this.videoSrc,
    this.videoTitle,
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
      sources: sources,
      videoSrc: convertValueByType(jsonRes['videoSrc'], String,
          stack: "VideoDetail-videoSrc"),
      videoTitle: convertValueByType(jsonRes['videoTitle'], String,
          stack: "VideoDetail-videoTitle"),
    );
  }

  Map<String, dynamic> toJson() => {
        'sources': sources,
        'videoSrc': videoSrc,
        'videoTitle': videoTitle,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Sources {
  List<Links> links;
  String sourceTitle;

  Sources({
    this.links,
    this.sourceTitle,
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
      links: links,
      sourceTitle: convertValueByType(jsonRes['sourceTitle'], String,
          stack: "Sources-sourceTitle"),
    );
  }

  Map<String, dynamic> toJson() => {
        'links': links,
        'sourceTitle': sourceTitle,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Links {
  String link;
  String title;

  Links({
    this.link,
    this.title,
  });

  factory Links.fromJson(jsonRes) => jsonRes == null
      ? null
      : Links(
          link:
              convertValueByType(jsonRes['link'], String, stack: "Links-link"),
          title: convertValueByType(jsonRes['title'], String,
              stack: "Links-title"),
        );

  Map<String, dynamic> toJson() => {
        'link': link,
        'title': title,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

// {
//  "videoTitle": "33",
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
