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
  final int lenth;
  SkeletonList({this.listTitle, this.lenth:10});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
          child: Column(
            children: List.filled(lenth, listTitle == null ?  DefaultListTitle() :listTitle),
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
