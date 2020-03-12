import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'defaultFullController.dart';
import 'portraitView.dart';
import 'tip.dart';


class CalcProgress {
  VideoInfo info;
  DragStartDetails startDetails;
  double dx;
  CalcProgress({this.info, this.startDetails});

  double calcTarget(DragUpdateDetails updateDetails) {
    dx = updateDetails.globalPosition.dx - startDetails.globalPosition.dx;
    double progress = getTarget() / info.duration;
    return progress;
  } 

  double getTarget() {
    double target = info.currentPosition + dx / 10;
    if (target < 0) {
      target = 0;
    } else if( target > info.duration) {
      target = info.duration;
    }
    return target;
  }
}

class DefaultIJKWidget extends StatefulWidget {
  final IjkMediaController controller;
  final bool doubleTapPlay;
  final bool playWillPauseOther;
  final bool fullScreen;
  final FullControllerWidget fullControllerWidget;
  final Widget portraitControllerWidget;
  DefaultIJKWidget(
      {@required this.controller,
      this.doubleTapPlay: true,
      this.fullScreen = false,
      this.fullControllerWidget,
      this.portraitControllerWidget,
      this.playWillPauseOther = true});
  @override
  _DefaultIJKWidgetState createState() => _DefaultIJKWidgetState();
}

class _DefaultIJKWidgetState extends State<DefaultIJKWidget>
    with  TipHelper{
  IjkMediaController get controller => widget.controller;
  VideoInfo get videoInfo => controller.videoInfo;
  bool get fullScreen => widget.fullScreen;
  GlobalKey currentKey = GlobalKey();
  StreamSubscription controllerSubscription;
  Timer progressTimer;
  Timer isShowTimer;

  /// 是否拖动进度条中
  bool _isDraging = false;

  CalcProgress _calcProgress;

  /// 是否显示控制器
  bool _isShow = false;
  bool get isShow => _isShow;
  set isShow(value) {
    
    if(mounted) {
      _isShow = value;
      setState(() {});
    }
  }

  void _onTextureIdChange(int textureId) {
    if (textureId != null) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  Function onDoubleTap() {
    return widget.doubleTapPlay ? controller.playOrPause : null;
  }

  onTap() {
    isShowTimer?.cancel();
    if (isShow == false) {
      isShowTimer = Timer(Duration(seconds: 5), () {
        isShow = false;
        isShowTimer = null;
      });
    }
    isShow = !isShow;
  }

  void startTimer() {
    if (controller.textureId == null) {
      return;
    }

    progressTimer?.cancel();
    progressTimer = Timer.periodic(Duration(milliseconds: 350), (timer) {
      if (!_isDraging) {
        controller.refreshVideoInfo();
      }
    });
  }

  void stopTimer() {
    progressTimer?.cancel();
  }

  Widget buildContent() {
    if (!isShow) {
      return Container();
    }
    return StreamBuilder<VideoInfo>(
      stream: controller.videoInfoStream,
      builder: (context, snapshot) {
        var info = snapshot.data;
        if (info == null || !info.hasData) {
          return Container();
        }
        var fullController = widget.fullControllerWidget != null ? widget.fullControllerWidget(this, controller) :
            DefaultFullController(
              controller: controller,
              info: info,
              tipHelper:this
            );
        var portraitController = widget.portraitControllerWidget ??
            PortraitController(
              controller: controller,
              fullControllerWidget: widget.fullControllerWidget,
              info: info,
              tipHelper: this,
            );
        return fullScreen ? fullController : portraitController;
      },
    );
  }

  void onHorizontalDragStart(DragStartDetails starDetails) {
    _calcProgress = CalcProgress(startDetails: starDetails, info: videoInfo);
  }

  onHorizontalDragUpdate(DragUpdateDetails updateDetails) {
    double progress =  _calcProgress.calcTarget(updateDetails);
    showTip(progress, videoInfo, fullScreen: widget.fullScreen);
  }

  onHorizontalDragEnd(DragEndDetails endDetails) async {
    hideTip();
    double target = _calcProgress.getTarget();
    if (target == null) {
      return;
    }
    await controller.seekTo(target);
    if (target < videoInfo.duration) await controller.play();
  }

  onVerticalDragStart(DragStartDetails startDetails) {

  }

  onVerticalDragUpdate(DragUpdateDetails updateDetails) {

  }

  onVerticalDragEnd(DragEndDetails endDetails) {

  }

 
  

  @override
  void initState() {
    super.initState();
    startTimer();
    controllerSubscription =
        controller.textureIdStream.listen(_onTextureIdChange);
  }

  @override
  void dispose() {
    controllerSubscription.cancel();
    stopTimer();
    IjkManager.resetBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: onDoubleTap(),
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onTap: onTap,
      key: currentKey,
      child: buildContent(),
    );
  }
}
