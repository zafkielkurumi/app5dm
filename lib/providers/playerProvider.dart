import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/apis/index.dart';
import 'package:app5dm/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PlayerModel extends BaseProvider {
  PlayerModel({@required String link, String noSourcePic}) {
    _noSourcePic = noSourcePic;
    getData(link);
  }

  VideoDetail _videoDetail;
  VideoDetail get videoDetail => _videoDetail;

  String _noSourcePic = '';
  String get noSourcePic => _noSourcePic;



  String _link = '';
  String get link => _link;

  IjkMediaController _playerController = IjkMediaController();
  IjkMediaController get playerController => _playerController;

  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  // num _height = Screen.setHeight(450);
  double _pinHeight = Screen.setHeight(450);
  double get pinHeight => _pinHeight;

  bool _isShowTitle = false;
  bool get isShowTitle => _isShowTitle;

  Future getData(String link) async {
    _link = link;
    try {
      VideoDetail detail = await VideoDetailApi.getVideoDetail(link);
      if (detail != null) {
        _videoDetail = detail;
        playerController.setNetworkDataSource(detail.videoSrc);
        setContent();
      } else {
        setUnAuth();
      }
    } catch (e) {
      onError(e);
    }
  }

  void changeLink(String link) {
     setPending();
     getData(link);
  }

  // void setOptions() {
  //   // var options = IjkOption(IjkOptionCategory., "skip_loop_filter", 48);
  //   playerController.setIjkPlayerOptions(
  //     [TargetPlatform.iOS, TargetPlatform.android],
  //   );
  // }

  changePlayPinHeight() {
    _pinHeight = Screen.setHeight(450);
    scrollController.position.applyContentDimensions(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent + _pinHeight);
  }

  changePausePinHeight() {
    _pinHeight = kToolbarHeight;
    scrollController.position.applyContentDimensions(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent + _pinHeight);
  }

  offsetListener() {
    if (scrollController.offset > Screen.setHeight(300) && !_isShowTitle) {
      _isShowTitle = true;
      setContent();
    } else if (scrollController.offset < Screen.setHeight(300) &&
        _isShowTitle) {
      _isShowTitle = false;
      setContent();
    }
  }

  initScroll() {
    scrollController.addListener(offsetListener);
  }

  removeLis() {
    scrollController.removeListener(offsetListener);
  }

  @override
  retry() {
    setFirst();
    getData(link);
  }

  @override
  void dispose() {
    playerController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }
}
