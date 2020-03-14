import 'package:flutter/material.dart';

class CustomRoute extends PageRoute {
  final WidgetBuilder builder;
  final bool isDismissible;
  CustomRoute({this.builder, this.isDismissible:true}) : assert(builder != null);

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => isDismissible;

  // 透明背景
  @override
  bool get opaque => false;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: RouteLayoutDelegate(progress: 1),
      child: builder(context),
    );
  }

  /// 页面切换动画
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(animation),
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}


class RouteLayoutDelegate extends SingleChildLayoutDelegate {
  RouteLayoutDelegate({this.progress, this.isScrollControlled: false});

  final double progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: 0.0,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight, /// 最大高度
    );
  }
  /// 显示的位置
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width * progress, 0.0);
  }

  @override
  bool shouldRelayout(RouteLayoutDelegate oldDelegate) {
    return progress != oldDelegate.progress;
  }
}