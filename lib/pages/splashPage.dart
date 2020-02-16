import 'package:app5dm/app5dm_route.dart' hide PageRouteType;
import 'package:app5dm/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
  name: "app5dm://splashPage",
  routeName: "splashPage",
  showStatusBar: false,
  pageRouteType: PageRouteType.transparent,
)


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
     Future.delayed(Duration(seconds: 1)).then((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.APP5DM_HOMEPAGE, (Route<dynamic> route) => false);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Image.asset(Images.loading),
    ),
    );
  }
}