import 'dart:convert' show json;
import './protect.dart';

class VideoItems {
  String title;
  String more;
  List<Seasons> seasons;

  VideoItems({
    this.title,
    this.more,
    this.seasons,
  });

  factory VideoItems.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Seasons> seasons = jsonRes['seasons'] is List ? [] : null;
    if (seasons != null) {
      for (var item in jsonRes['seasons']) {
        if (item != null) {
          tryCatch(() {
            seasons.add(Seasons.fromJson(item));
          });
        }
      }
    }
    return VideoItems(
      title: convertValueByType(jsonRes['title'], String, stack: "VideoItems-title"),
      more: convertValueByType(jsonRes['more'], String, stack: "VideoItems-more"),
      seasons: seasons,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'more': more,
        'seasons': seasons,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Seasons {
  String imgUrl;
  String stringId;
  String title;

  Seasons({
    this.imgUrl,
    this.stringId,
    this.title,
  });

  factory Seasons.fromJson(jsonRes) => jsonRes == null
      ? null
      : Seasons(
          imgUrl: convertValueByType(jsonRes['imgUrl'], String,
              stack: "Seasons-imgUrl"),
          stringId: convertValueByType(jsonRes['stringId'], String,
              stack: "Seasons-stringId"),
          title: convertValueByType(jsonRes['title'], String,
              stack: "Seasons-title"),
        );

  Map<String, dynamic> toJson() => {
        'imgUrl': imgUrl,
        'stringId': stringId,
        'title': title,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

// {
//  "title": "4",
//  "more": "5",
//  "seasons": [
//   {
//   "imgUrl": "4",
//   "stringId": "4",
//   "title":"5"
// }
// ]
// }
