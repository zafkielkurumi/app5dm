import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/pages/test/demo.dart';
import 'package:app5dm/pages/test/testPage.dart';
import 'package:app5dm/pages/test/testRoutePage.dart';
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
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ));
              },
              child: Text('测试'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(CustomRoute(builder: (context)=> TestRoutePage()));
              },
              child: Text('测试自定义路由'),
            ),
            RaisedButton(
              onPressed: () {
                 Navigator.of(context).push(CustomRoute(builder: (context)=> DemoPage()));
              },
              child: Text('测试bottom'),
            ),
          ],
        );
  }
}