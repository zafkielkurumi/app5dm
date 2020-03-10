import 'dart:io';

import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/playerUi/CustomProgressBar.dart';
import 'package:app5dm/widgets/playerUi/fullScreen.dart';
import 'package:app5dm/widgets/playerUi/tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

typedef Widget FullControllerWidget(
    TipHelper tipHelper, IjkMediaController controller);

class PortraitController extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;
  final bool playWillPauseOther;
  final TipHelper tipHelper;
  final FullControllerWidget fullControllerWidget;
  PortraitController(
      {Key key,
      @required this.controller,
      @required this.info,
      this.tipHelper,
      this.fullControllerWidget,
      this.playWillPauseOther})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!info.hasData || info.duration <= 0) {
      return Container();
    }
    return Column(
      children: <Widget>[
        PortaitHeader(),
        Expanded(
          child: Container(),
        ),
        PortaitFooter(
            controller: controller,
            info: info,
            tipHelper: tipHelper,
            fullControllerWidget: fullControllerWidget)
      ],
    );
  }
}

class PortaitFooter extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;
  final bool playWillPauseOther;
  final TipHelper tipHelper;
  final FullControllerWidget fullControllerWidget;
  const PortaitFooter(
      {Key key,
      @required this.controller,
      @required this.info,
      this.tipHelper,
      this.fullControllerWidget,
      this.playWillPauseOther = true})
      : super(key: key);
  bool get haveTime {
    return info.hasData && info.duration > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Color.fromARGB(200, 0, 0, 0),
            Color.fromARGB(0, 0, 0, 0),
          ])),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              controller.playOrPause(pauseOther: playWillPauseOther);
            },
            icon: Icon(
              info.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            iconSize: 25.0,
          ),
          Expanded(
            child: Container(
              height: 22,
              child: CustomProgressBar(
                  max: info.duration,
                  current: info.currentPosition,
                  playedColor: Theme.of(context).primaryColor,
                  changeProgressHandler: (progress) async {
                    await controller.seekToProgress(progress);
                    tipHelper.hideTip();
                  },
                  tapProgressHandler: (progress) {
                    tipHelper.showTip(progress, controller.videoInfo);
                  }),
            ),
          ),
          Text(
            TimeHelper.getTimeText(info.currentPosition),
            style: TextStyle(color: Colors.white),
          ),
          haveTime
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '/',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SizedBox.shrink(),
          Text(
            TimeHelper.getTimeText(info.duration),
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
              icon: Icon(
                Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlayerFullScreen(controller, fullControllerWidget)));
              })
        ],
      ),
    );
  }
}

class PortaitHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(200, 0, 0, 0),
            Color.fromARGB(0, 0, 0, 0),
          ])),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
