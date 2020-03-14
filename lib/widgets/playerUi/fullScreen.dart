import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:sensors/sensors.dart';
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
  StreamSubscription accelerometer;
  double _angle = 0;
  /// false为left。 ture为right
  bool landscapeLeftOrRight = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    accelerometer = accelerometerEvents.listen((AccelerometerEvent  event) {
      double dx = event.x;
      if (dx > 7 && landscapeLeftOrRight) {
        landscapeLeftOrRight = false;
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      } else if (dx < -7 && !landscapeLeftOrRight) {
        landscapeLeftOrRight = true;
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      }
    });
    
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    accelerometer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Transform.rotate(
          angle: _angle,
          child: Player(
            controller: widget.controller,
            fullScreen: true,
            fullControllerWidget: widget.fullControllerWidget,
          ),
        ),
        onWillPop: () async {
          await SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp]);
          return true;
        });
  }
}
