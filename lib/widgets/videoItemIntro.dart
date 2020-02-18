import 'package:flutter/material.dart';
import 'imageView.dart';
class VideoItemIntroduce extends StatelessWidget {
  final String imgUrl;
  final String link;
  final String title;
  VideoItemIntroduce({this.imgUrl, this.link, this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          ImageView(url: imgUrl, boxFit: BoxFit.fill,),
          Text('$title', maxLines: 2, overflow: TextOverflow.ellipsis,)
      ],
    );
  }
}