import 'package:app5dm/app5dm_route.dart' hide PageRouteType;
import 'package:app5dm/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
  name: "/searchPage",
  routeName: "searchPage",
  showStatusBar: false,
  pageRouteType: PageRouteType.transparent
)

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(child: TextField(
              onSubmitted: (value) {
                Navigator.of(context).pushNamed(Routes.SEARCHRESULTPAGE, arguments: {
                  "keyword": value
                });
              },
              autofocus: true,
              decoration: InputDecoration(),
            ),),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: Screen.setWidth(100),
                child: Text('取消'),
              ),
            )
          ],
        ),
      ),
    );
  }
}