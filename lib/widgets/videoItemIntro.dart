import 'package:app5dm/utils/index.dart';
import 'package:flutter/material.dart';
import 'imageView.dart';
class VideoItemIntroduce extends StatelessWidget {
  final String imgUrl;
  final String link;
  final String title;
  final double width;
  VideoItemIntroduce({this.imgUrl, this.link, this.title, this.width});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          Container(
            width: width,
            height: tranferImageWidthToHeiht(width),
            child: ImageView(url: imgUrl, boxFit: BoxFit.fitWidth, width: width,),
          ),
          Text('$title', maxLines: 2, overflow: TextOverflow.ellipsis,)
      ],
    );
  }
}