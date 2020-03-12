import 'dart:io';

import 'package:app5dm/providers/playerProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/customRoute.dart';
import 'package:app5dm/widgets/playerUi/CustomProgressBar.dart';
import 'package:app5dm/widgets/playerUi/tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class FullController extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;
  final bool playWillPauseOther;
  final TipHelper tipHelper;
  final PlayerModel playerModel;
  FullController(
      {Key key,
      @required this.controller,
      @required this.info,
      this.tipHelper,
      @required this.playerModel,
      this.playWillPauseOther})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!info.hasData) {
      return Container();
    }
    return Column(
      children: <Widget>[
        FullHeader(playerModel),
        Expanded(
          child: Container(
              // child: ProgressBar(),
              ),
        ),
        Container(
          height: 22,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomProgressBar(
              max: info.duration,
              current: info.currentPosition,
              playedColor: Theme.of(context).primaryColor,
              changeProgressHandler: (progress) async {
                await controller.seekToProgress(progress);
                tipHelper.hideTip();
              },
              tapProgressHandler: (progress) {
                tipHelper.showTip(progress, controller.videoInfo,
                    fullScreen: true);
              }),
        ),
        FullFooter(
          controller: controller,
          info: info,
          tipHelper: tipHelper,
          playerModel: playerModel,
        )
      ],
    );
  }
}

class FullFooter extends StatelessWidget {
  const FullFooter(
      {Key key,
      @required this.controller,
      @required this.info,
      this.tipHelper,
      this.playerModel,
      this.playWillPauseOther = true})
      : super(key: key);

  final IjkMediaController controller;
  final VideoInfo info;
  final bool playWillPauseOther;
  final TipHelper tipHelper;
  final PlayerModel playerModel;
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
          IconButton(
              icon: Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
              onPressed: () {
                playerModel.nextSeason();
              }),
          Expanded(child: Container()),
          buildCurrentTime(),
          haveTime
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '/',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SizedBox.shrink(),
          buildMaxTime(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(CustomRoute(
                    builder: (context) => _SelectSeason(playerModel)));
              },
              child: Text(
                '选集',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                '倍速',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.fullscreen_exit,
              color: Colors.white,
            ),
            onPressed: () async {
              await SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}

class FullHeader extends StatelessWidget {
  final PlayerModel playerModel;
  FullHeader(this.playerModel);
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
            onPressed: () async {
              await SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Text(
              '第${playerModel.findLinkIndex() + 1}话',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class _SelectSeason extends StatelessWidget {
  final PlayerModel playerModel;
  _SelectSeason(this.playerModel);
  @override
  Widget build(BuildContext context) {
    var source = playerModel.findSource();
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.topCenter,
        width: 300,
        height: double.infinity,
        color: Colors.black.withAlpha(220),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            children: List.generate(
              source.links.length,
              (index) {
                var link = source.links[index];
                return Container(
                  width: 50,
                  child: OutlineButton(
                    borderSide: BorderSide(
                        color: playerModel.link == link.link
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                    onPressed: () {
                      playerModel.getData(link.link);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
