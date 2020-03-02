import 'package:flutter/material.dart';
import 'dart:math';

enum  RouteType  {
  opactity,
  rotate
}


class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  final routeType;
  CustomRoute(this.widget, { this.routeType: RouteType.rotate})
      : super(pageBuilder: (context, animation, secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          //  return FadeTransition(
          //     opacity: animation,
          //     child: child,
          //   );
          return Transform.rotate(angle: pi / 2, child: child,);
        });
  
}
