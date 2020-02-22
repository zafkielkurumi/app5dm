import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('请先登录'),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            // Navigator.of(context).pop(false);
          },
          child: Text('取消'),
        ),
        CupertinoDialogAction(
          onPressed: () async {
            // Navigator.of(context).pop(true);
          },
          child: Text('确定'),
        ),
      ],
    );
  }
}

