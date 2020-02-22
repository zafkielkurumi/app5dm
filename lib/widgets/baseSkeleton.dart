import 'package:app5dm/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircle;
  SkeletonBox(
      {this.height: 15, this.width: double.infinity, this.isCircle: false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          // color: Color(0xf2f2f2),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final Widget listTitle;
  final int length;
  SkeletonList({this.listTitle, this.length:10});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
          child: Column(
            children: List.filled(length, listTitle == null ?  DefaultListTitle() :listTitle),
          ),
          baseColor: Colors.grey[350],
          highlightColor: Colors.grey[200]),
    );
  }
}

class SkeletonGirdList extends StatelessWidget {
  final Widget listTitle;
  final int length;
  final int count;
  SkeletonGirdList({this.listTitle, this.length:20, this.count:2});
  @override
  Widget build(BuildContext context) {
    var itemWidth = (Screen.width - 20 - Screen.setWidth(20)) / count;
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
          child: Wrap(
          spacing: Screen.setWidth(20),
          runSpacing: Screen.setWidth(10),
          children: List.filled(
            length,
            Container(
              width: itemWidth,
              child: listTitle == null ? DefaultSkeletonGridItem() : listTitle,
            ),
          ),
        ),
          baseColor: Colors.grey[350],
          highlightColor: Colors.grey[200]),
    );
  }
}



class DefaultListTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SkeletonBox(),
    );
  }
}

class DefaultSkeletonGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SkeletonBox(
          height: Screen.setHeight(200),
        ),
        SizedBox(height: 10,),
        SkeletonBox(
          width: Screen.setWidth(200),
        ),
        SizedBox(height: 10,),
        SkeletonBox(),
      ],
    );
  }
}



