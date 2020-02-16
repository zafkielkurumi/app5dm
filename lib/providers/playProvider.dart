import 'package:app5dm/models/videoDetal_model.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/apis/index.dart';

class PlayerProvderModel extends BaseProvider {
  PlayerProvderModel(String link) {
    getData(link);
  }
  String _videoSrc;
  String _viderTitle;
  List<Sources> _sources = [];
  String _link;

  Future getData(String link) async {
    _link = link;
    try {
      VideoDetail videoDetail = await VideoDetailApi.getVideoDetail(link);
    _videoSrc = videoDetail.videoSrc;
    _viderTitle = videoDetail.videoTitle;
    _sources = videoDetail.sources;
    setContent();
    } catch (e) {
      onError();
    }
  }
  @override
  retry() {
    setFirst();
    getData(link);
  }

  String get videoSrc => _videoSrc;
  String get viderTitle => _viderTitle;
  List<Sources> get sources => _sources;
  String get link => _link;
}