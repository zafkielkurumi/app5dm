import 'package:app5dm/models/index.dart';
import './baseProvider.dart';
import 'package:app5dm/apis/homeApi.dart';

class SerialModel extends BaseProvider {
  SerialModel(link) {
    loadData(link);
  }

  String _link;
  get link => _link;

  int _page = 1;
  // String


  List<Seasons> serials = [];

  loadData(value) async {
    _link = value;
    try {
      serials = await HomeApi.getSerial(link: _link, page: _page);
      setContent();
    } catch (e) {
      onError(e);
    }
  }

  @override
  retry() {
    setFirst();
    loadData(link);
  }

  Future refresh() async {
    _page = 1;
    await loadData(link);
  }
}
