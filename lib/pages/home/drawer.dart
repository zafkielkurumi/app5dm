import 'package:app5dm/app5dm_route.dart';
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

          ],
        );
  }
}