import 'package:app5dm/providers/baseProvider.dart';
import './skeleton.dart';
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
          case ViewState.content: return child;
          case ViewState.error: return ErrorView<T>();
          
          case ViewState.first:
          default: return skelelon == null ? SkeletonList() : skelelon;
        }
      },
      selector: (c, view) => view.viewState,
      child: child,
    );
  }
}

class ErrorView<T extends BaseProvider>  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlineButton(onPressed: Provider.of<T>(context).retry, child: Text('重试'),),
    );
  }
}
