import 'dart:async';

import 'package:app5dm/constants/config.dart';
import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/apis/index.dart';
import 'package:app5dm/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PlayerModel extends BaseProvider {
  PlayerModel({@required String link, String noSourcePic,}) {
    _noSourcePic = noSourcePic;
    var url = link + '?link=0';
    initListener();
    getData(url);
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

  double _pinHeight = playerHeight;
  double get pinHeight =>_pinHeight;


  bool _isShowTitle = false;
  bool get isShowTitle => _isShowTitle;

  bool _isPlaying = true;

  StreamSubscription _videoSteam;

  Future getData(String link) async {
    _link = link;
    setContent();
    // try {
    //   VideoDetail detail = await VideoDetailApi.getVideoDetail(link);
    //   if (detail != null) {
    //     _videoDetail = detail;
    //     playerController.setNetworkDataSource(detail.videoSrc);
    //     setContent();
    //   } else {
    //     setUnAuth();
    //   }
    // } catch (e) {
    //   onError(e);
    // }
  }
  /// 
  void changeLink(String link) {
    setPending();
    getData(link);
  }
  /// 下一集
  nextSeason() {
     setPending();
     var url = findLink();
     if (url.isNotEmpty) {
       getData(url);
     } else {
       setContent();
     }
  }

  Sources findSource() {
    for (var source in videoDetail.sources) {
        var index = source.links.indexWhere((r) => r.link == link);
        if(index > -1) {
          return source;
        }
     }
     return null;
  }
  /// 查找第几话
  int findLinkIndex() {
     for (var source in videoDetail.sources) {
        var index = source.links.indexWhere((r) => r.link == link);
        if(index > -1) {
          return index;
        }
     }
     return -1;
  }

  String findLink() {
    for (var source in videoDetail.sources) {
        var index = source.links.indexWhere((r) => r.link == link);
        if(index > -1 && index < source.links.length) {
          return source.links[index + 1].link;
        }
     }
     return '';
  }

  // void setOptions() {
  //   // var options = IjkOption(IjkOptionCategory., "skip_loop_filter", 48);
  //   playerController.setIjkPlayerOptions(
  //     [TargetPlatform.iOS, TargetPlatform.android],
  //   );
  // }



  changePinHeight(double pinHeight) {
    _pinHeight = pinHeight;
    scrollController.position.applyContentDimensions(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent + pinHeight);
        notifyListeners();
  }
  testchangePinHeight() {
    _pinHeight = _pinHeight == playerHeight ? kToolbarHeight :playerHeight;
    // scrollController.position.applyContentDimensions(
    //     scrollController.position.minScrollExtent,
    //     scrollController.position.maxScrollExtent + _pinHeight);
        // notifyListeners();
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

  initListener() {
    scrollController.addListener(offsetListener);
    _videoSteam = playerController.videoInfoStream.listen((info) {
      if (_isPlaying != info.isPlaying) {
        _isPlaying = info.isPlaying;
        changePinHeight((_isPlaying? playerHeight: kToolbarHeight) + Screen.statusHeight);
      }
    });
  }


  @override
  retry() {
    setFirst();
    getData(link);
  }

  @override
  void dispose() {
    _videoSteam?.cancel();
    playerController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }
}
