import 'dart:async';
import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/apis/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PlayerModel extends BaseProvider {
  PlayerModel({
    @required String link,
    @required this.playController,
    String noSourcePic,
  }) {
    _noSourcePic = noSourcePic;
    var url = link + '?link=0';
    getData(url);
  }

  VideoDetail _videoDetail;
  VideoDetail get videoDetail => _videoDetail;

  String _noSourcePic = '';
  String get noSourcePic => _noSourcePic;

  String _link = '';
  String get link => _link;

  bool _isShowSheet = false;
  bool get isShowSheet => _isShowSheet;


  IjkMediaController playController;

  // 仅实现第一个sources
  ScrollController briefSc =ScrollController(); //

   List<Links> _links = [];
  List<Links>  get links => _links;


  Future getData(String link) async {
    _link = link;
    // briefSc.jumpTo(value)
    try {
      VideoDetail detail = await VideoDetailApi.getVideoDetail(link);
      if (detail != null) {
        _videoDetail = detail;
        playController.setNetworkDataSource(detail.videoSrc, autoPlay: true);
        setContent();
      } else {
        setUnAuth();
      }
    } catch (e) {
      onError(e);
    }
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

  List<Links> findLinks() {
    for (var source in videoDetail.sources) {
      var index = source.links.indexWhere((r) => r.url == link);
      if (index > -1) {
        return source.links;
      }
    }
    return [];
  }

  /// 查找第几话
  int findLinkIndex() {
    for (var source in videoDetail.sources) {
      var index = source.links.indexWhere((r) => r.url == link);
      if (index > -1) {
        return index;
      }
    }
    return -1;
  }

  String findLink() {
    for (var source in videoDetail.sources) {
      var index = source.links.indexWhere((r) => r.url == link);
      if (index > -1 && index < source.links.length) {
        return source.links[index + 1].url;
      }
    }
    return '';
  }

  showModelSheet() {
    if (!_isShowSheet) {
       _links = findLinks();
    }
    _isShowSheet = !_isShowSheet;
    notifyListeners();
  }

  // void setOptions() {
  //   // var options = IjkOption(IjkOptionCategory., "skip_loop_filter", 48);
  //   playerController.setIjkPlayerOptions(
  //     [TargetPlatform.iOS, TargetPlatform.android],
  //   );
  // }



  @override
  retry() {
    setFirst();
    getData(link);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
