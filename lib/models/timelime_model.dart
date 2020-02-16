import 'dart:convert' show json;
import './protect.dart';

class Timeline {
  List<Seasons> seasons;
  String title;

  Timeline({
    this.seasons,
    this.title,
  });

  factory Timeline.fromJson(jsonRes) {
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
    return Timeline(
      seasons: seasons,
      title: convertValueByType(jsonRes['title'], String, stack: "Timeline-title"),
    );
  }

  Map<String, dynamic> toJson() => {
        'seasons': seasons,
        'title': title,
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
