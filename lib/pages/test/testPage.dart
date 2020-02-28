import 'package:app5dm/providers/testProvider.dart';
import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "/TestPage",
  routeName: "TestPage",
  showStatusBar: true,
)
class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<TestModel>(
        create: (_) => TestModel(),
        child: Selector<TestModel, List>(
            selector: (_, testModel) => testModel.numberList,
            // shouldRebuild: (prev, next) => prev.first != next.first,
            builder: (ctx, numberList, child) {
              return Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Provider.of<TestModel>(ctx, listen: false).changeNumber();
                    },
                    child: Text(numberList.first.toString()),
                  ),
                  Text(numberList.last.toString())
                ],
              );
            }),
      ),
    );
  }
}
