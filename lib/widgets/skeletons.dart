import 'package:flutter/material.dart';
import 'package:app5dm/utils/index.dart';

import 'baseSkeleton.dart';
class TimeTableSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          SkeletonBox(
            height: Screen.setHeight(113),
            width: Screen.setWidth(200),
          ),
          SizedBox(
            width: Screen.setWidth(10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SkeletonBox(
                  width: Screen.setWidth(200),
                ),
                SizedBox(
                  height: Screen.setHeight(20),
                ),
                SkeletonBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}

