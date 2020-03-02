import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'player.dart';

class PlayerFullScreen extends StatefulWidget {
  final IjkMediaController controller;
  PlayerFullScreen(this.controller);
  @override
  _PlayerFullScreenState createState() => _PlayerFullScreenState();
}

class _PlayerFullScreenState extends State<PlayerFullScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RotatedBox(quarterTurns: 1, child: Player(
      controller: widget.controller,
      fullScreen: true
    ),);
  }
}