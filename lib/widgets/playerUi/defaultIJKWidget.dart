import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'package:flutter/cupertino.dart';

import 'fullController.dart';
import 'portraitView.dart';


class DefaultIJKWidget extends StatefulWidget {
  final IjkMediaController controller;
  final bool doubleTapPlay;
  final bool playWillPauseOther;
  final bool fullScreen;
  final Widget fullControllerWidget;
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

class _DefaultIJKWidgetState extends State<DefaultIJKWidget> {
  IjkMediaController get controller => widget.controller;
  VideoInfo get videoInfo => controller.videoInfo;
  GlobalKey currentKey = GlobalKey();
  StreamSubscription controllerSubscription;
  Timer progressTimer;
  Timer isShowTimer;
  OverlayEntry _overlayTip;

  bool _isShow = true;
  bool get  isShow => _isShow;
  set isShow(value) {
    _isShow = value;
    setState(() {
      
    });
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
      isShowTimer = Timer(Duration(seconds: 10), () {
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
      controller.refreshVideoInfo();
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
        var fullController = widget.fullControllerWidget ?? FullController(controller: controller, info: info,);
        var portraitController = widget.portraitControllerWidget ?? PortraitController(controller: controller, info: info,);
        return widget.fullScreen ? fullController : portraitController;
      },
    );
  }

  void onHorizontalDragStart( DragStartDetails starDetails ) {
    // showTip();
  }
  onHorizontalDragEnd(DragEndDetails endDetails) {
    hideTip();
  }
  void showTip() {
    hideTip();
     _overlayTip = OverlayEntry(builder: (context) {
      Widget w = IgnorePointer(child: Center(
        child: Text('fsdfsdfsdfsd'),
      ),);
      if( widget.fullScreen) {
        w = RotatedBox(quarterTurns: 1, child: w,);
      }
      return w;
    });
    Overlay.of(context).insert(_overlayTip);
  }
  void hideTip() {
    _overlayTip?.remove();
    _overlayTip = null;
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
    /// deferToChild：子widget会一个接一个的进行命中测试，如果子Widget中有测试通过的，
    /// 则当前Widget通过，这就意味着，如果指针事件作用于子Widget上时，其父(祖先)Widget也肯定可以收到该事件。
    /// opaque：在命中测试时，将当前Widget当成不透明处理(即使本身是透明的)，最终的效果相当于当前Widget的整个区域都是点击区域
    /// translucent：当点击Widget透明区域时，可以对自身边界内及底部可视区域都进行命中测试，这意味着点击顶部widget透明区域时，顶部widget和底部widget都可以接收到事件
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: onDoubleTap(),
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onTap: onTap,
      key: currentKey,
      child: buildContent(),
    );
  }
}
