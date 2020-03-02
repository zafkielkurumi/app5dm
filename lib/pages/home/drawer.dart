import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/pages/test/testPage.dart';
import 'package:app5dm/widgets/customRoute.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.LOGINPAGE);
              },
              child: Text('登录测试'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.TESTPAGE);
              },
              child: Text('测试'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(CustomRoute(TestPage()));
              },
              child: Text('测试自定义路由'),
            ),
          ],
        );
  }
}