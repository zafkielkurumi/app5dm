import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/apis/index.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PlayerModel extends BaseProvider {
  PlayerModel(String link) {
    getData(link);
  }
  String _videoSrc = '';
  String _videoTitle = '';
  List<Sources> _sources = [];
  String _link = '';
  IjkMediaController _controller = IjkMediaController();

  Future getData(String link) async {
    _link = link;
    try {
      var videoDetail = await VideoDetailApi.getVideoDetail(link);
      if (videoDetail != null) {
        _videoSrc = videoDetail.videoSrc;
        _videoTitle = videoDetail.videoTitle;
        _sources = videoDetail.sources;
        controller.setNetworkDataSource(_videoSrc);
        setContent();
      } else {
        setUnAuth();
      }
    } catch (e) {
      onError(e);
    }
  }

  @override
  retry() {
    setFirst();
    getData(link);
  }

  String get videoSrc => _videoSrc;
  String get videoTitle => _videoTitle;
  List<Sources> get sources => _sources;
  String get link => _link;
  IjkMediaController get controller => _controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
