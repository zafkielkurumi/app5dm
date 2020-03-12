import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/constants/images.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/utils/index.dart';
import './baseSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewWidget<T extends BaseProvider> extends StatelessWidget {
  final Widget child;
  final Widget skelelon;
  ViewWidget({this.child, this.skelelon});
  @override
  Widget build(BuildContext context) {
    return Selector<T, ViewState>(
      builder: (c, viewstate, child) {
        switch (viewstate) {
          case ViewState.content:
          case ViewState.pending:
            return child;
          case ViewState.error:
            return ErrorView<T>();
          case ViewState.unAuth:
            return UnAuthView<T>();
          case ViewState.first:
          default:
            return skelelon == null ? SkeletonList() : skelelon;
        }
      },
      selector: (c, view) => view.viewState,
      child: child,
    );
  }
}

class ErrorView<T extends BaseProvider> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<T>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('${model.errorMessage}'),
        SizedBox(height: 10,),
        OutlineButton(
          onPressed: model.retry,
          child: Text('重试'),
        )
      ],
    );
  }
}

class UnAuthView<T extends BaseProvider> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
              tag: 'logo',
              child: Image.asset(
                Images.logo,
              )),
          SizedBox(
            height: Screen.setHeight(20),
          ),
          Text('未登录'),
          SizedBox(
            height: Screen.setHeight(250),
          ),
          OutlineButton(
            onPressed: () async {
              var res = await Navigator.of(context).pushNamed(Routes.LOGINPAGE);
              if (res == true) {
                Provider.of<T>(context, listen: false).retry();
              }
            },
            child: Text('登录'),
          ),
        ],
      ),
    );
  }
}
