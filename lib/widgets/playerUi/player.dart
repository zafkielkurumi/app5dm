import 'package:app5dm/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'IjkStatusWidgets.dart';
import './DefaultIJKWidget.dart';
import 'portraitView.dart';




class Player extends StatelessWidget {
  final IjkMediaController controller;
  final String noSourcePic;
  final bool fullScreen;
  final FullControllerWidget fullControllerWidget;
  const Player({
    Key key,
    @required this.controller,
    this.fullScreen = false,
    this.noSourcePic,
    this.fullControllerWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: playerHeight,
      child: IjkPlayer(
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
          fullControllerWidget: fullControllerWidget,
        ); // 自定义
      },
    ),
    );
  }
}
