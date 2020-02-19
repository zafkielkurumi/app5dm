import 'package:app5dm/apis/searchApi.dart';
import 'package:app5dm/models/index.dart';
import 'package:flutter/foundation.dart';
import './baseProvider.dart';

class SearchModel extends BaseProvider {
  SearchModel(value) {
    loadData(value);
  }

  int _page = 1;
  get page => _page;

  String _keyword = '';
  set keyword(value) {
    _keyword = value;
  }
  String get keyword => _keyword;

  List<VideoItems> videoItems = [];

  loadData(String value) async {
    keyword = value;
    try {
      videoItems = await SearchApi.search(keyword, page);
      setContent();
    } catch (e) {
      onError();
      debugPrint(e.toString());
    }
  }
  loadmore() async {
    _page++;
    await loadData(keyword);
  }

  Future refresh() async {
    _page = 1;
    await loadData(keyword);
  }

  @override
  retry() {
    setFirst();
    loadData(keyword);
  }

  
}
