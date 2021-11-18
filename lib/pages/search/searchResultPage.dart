import 'package:app5dm/providers/searchProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/viewWidget.dart';
import 'package:flutter/material.dart';
// import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:provider/provider.dart';

// @FFRoute(
//     name: "/searchResultPage",
//     routeName: "searchResultPage",
//     argumentNames: ["keyword"],
//     pageRouteType: PageRouteType.transparent)
class SearchResultPage extends StatelessWidget {
  final String keyword;
  SearchResultPage({this.keyword});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SearchModel>(create: (_) => SearchModel(keyword), child: ViewWidget<SearchModel>(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              elevation: 0,
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(),
                    ),
                  ),
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
            SliverGrid.count(crossAxisCount: 2, children: <Widget>[
            ],)
          ],
        ),
      ),),
    );
  }
}
