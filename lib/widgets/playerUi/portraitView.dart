import 'dart:async';
import 'dart:io';

import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/playerUi/CustomProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PortraitController extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;
  final bool playWillPauseOther;
  PortraitController(
      {Key key,
      @required this.controller,
      @required this.info,
      this.playWillPauseOther})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!info.hasData) {
      return Container();
    }
    return Column(
      children: <Widget>[
        PortaitHeader(),
        Expanded(
          child: Container(
              // child: ProgressBar(),
              ),
        ),
        PortaitFooter(controller: controller, info: info)
      ],
    );
  }
}

class PortaitFooter extends StatelessWidget {
  const PortaitFooter(
      {Key key,
      @required this.controller,
      @required this.info,
      this.playWillPauseOther = true})
      : super(key: key);

  final IjkMediaController controller;
  final VideoInfo info;
  final bool playWillPauseOther;
  bool get haveTime {
    return info.hasData && info.duration > 0;
  }

  Widget buildCurrentTime() {
    return haveTime
        ? Text(
            TimeHelper.getTimeText(info.currentPosition),
            style: TextStyle(color: Colors.white),
          )
        : Container();
  }

  Widget buildMaxTime() {
    return haveTime
        ? Text(
            TimeHelper.getTimeText(info.duration),
            style: TextStyle(color: Colors.white),
          )
        : Container();
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
              },
              tapProgressHandler: (progress) {
                
              }
            ),
            ),
          ),
          buildCurrentTime(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '/',
              style: TextStyle(color: Colors.white),
            ),
          ),
          buildMaxTime(),
          IconButton(
              icon: Icon(
                Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: null)
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