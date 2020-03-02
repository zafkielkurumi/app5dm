import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'IjkStatusWidgets.dart';
import './DefaultIJKWidget.dart';

class Player extends StatelessWidget {
  final IjkMediaController controller;
  final String noSourcePic;
  final bool fullScreen;
  const Player({
    Key key,
    @required this.controller,
    this.fullScreen = false,
    this.noSourcePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IjkPlayer(
      mediaController: controller,
      statusWidgetBuilder: (ctx, mediaController, status) {
        if (status == IjkStatus.noDatasource) {
          return PreparingView();
        }

        if (status == IjkStatus.preparing) {
          return PreparingView();
        }
        if (status == IjkStatus.prepared) {
          return PreparedView(controller);
        }
        if (status == IjkStatus.error) {
          return ErrorView();
        }
        if (status == IjkStatus.pause) {
          return PauseView(controller);
        }
        if (status == IjkStatus.complete) {
          return CompleteView(controller); 
        }
        return Container();
      },
      controllerWidgetBuilder: (mediaController) {
        return DefaultIJKWidget(
          controller: mediaController,
          fullScreen: fullScreen,
        ); // 自定义
      },
    );
  }
}
