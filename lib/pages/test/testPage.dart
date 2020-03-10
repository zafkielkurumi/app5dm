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
            builder: (ctx, numberList, child) {
              TestModel model = Provider.of<TestModel>(ctx, listen: false);
              return Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      model.changeNumber();
                    },
                    child: Text(numberList.first.toString()),
                  ),
                  Text(numberList.last.toString()),
                  RaisedButton(
                    onPressed: () {
                      model.changeString2();
                    },
                    child: Selector<TestModel, String>(
                      child: Selector<TestModel, String>(
                        builder: (_, string1, child) {
                          print('string1');
                          return InkWell(
                            onTap: model.changeString1,
                            child: Text(string1),
                          );
                        },
                        selector: (_, testModel) => testModel.string1,
                      ),
                      builder: (_, string2, child) {
                        print('string2');
                        return Row(
                          children: <Widget>[Text(string2), child],
                        );
                      },
                      selector: (_, testModel) => testModel.string2,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
