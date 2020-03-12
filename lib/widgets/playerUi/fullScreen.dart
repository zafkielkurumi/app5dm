import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'player.dart';
import 'portraitView.dart';

class PlayerFullScreen extends StatefulWidget {
  final IjkMediaController controller;
  final FullControllerWidget fullControllerWidget;
  PlayerFullScreen(this.controller, this.fullControllerWidget);
  @override
  _PlayerFullScreenState createState() => _PlayerFullScreenState();
}

class _PlayerFullScreenState extends State<PlayerFullScreen> {
  StreamSubscription gyroscope;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    // gyroscope = gyroscopeEvents.listen((GyroscopeEvent event) {
    //   print('event');
    //   print(event);
    // });
    // Wakelock.toggle(on: true);
    super.initState();
  }

  @override
  void dispose() {
   SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // Wakelock.toggle(on: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
          quarterTurns: 0,
          child: Player(
            controller: widget.controller,
            fullScreen: true,
            fullControllerWidget: widget.fullControllerWidget,
          ),
        );
  }
}
