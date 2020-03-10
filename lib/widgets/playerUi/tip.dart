import 'package:app5dm/constants/config.dart';
import 'package:app5dm/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

mixin TipHelper<T extends StatefulWidget> on State<T> {
  OverlayEntry _overlayTip;
  showTip(double progress, VideoInfo info, {fullScreen: false}) {
    hideTip();
    double target = info.duration * progress;
    double tipHeigt = 40;
    double tipWidth = 100;
    double top = ((fullScreen ? Screen.width  : playerHeight) - tipHeigt) / 2;
    double left = ((fullScreen ? Screen.height : Screen.width )- tipWidth) / 2;
    _overlayTip = OverlayEntry(builder: (context) {
      Widget w = IgnorePointer(
        child: Material(
            textStyle: TextStyle(color: Colors.white),
            type: MaterialType.card,
            child: Container(
              color: Colors.black87,
              width: tipWidth,
              height: tipHeigt,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(TimeHelper.getTimeText(target)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text('/'),
                    ),
                    Text(TimeHelper.getTimeText(info.duration))
                  ],
                ),
              ),
            ),
          ),
      );
      
      // if (fullScreen) {
      //   w =  RotatedBox(quarterTurns: 1, child: Center(
      //     child: w,
      //   ),);
      // } else {
      //   w = Positioned(
      //   top: top,
      //   left: left,
      //   child: w,
      // );
      // }
      return Positioned(
        top: top,
        left: left,
        child: w,
      );
    });
    Overlay.of(context).insert(_overlayTip);
  }

  void hideTip() {
    _overlayTip?.remove();
    _overlayTip = null;
  }
}
