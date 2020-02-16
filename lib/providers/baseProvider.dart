import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/cupertino.dart';

enum ViewState {
  first, // 默认值，第一次进入显示
  error, // 错误, 重新获取
  empty, // 无数据
  unAuth, // 未登录
  content,
}

 class BaseProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.first;
  bool _dispose = false;

  ViewState get viewState => _viewState;

  setViewSate(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  setUnAuth() {
    setViewSate(ViewState.unAuth);
    showToast('需要登录');
  }

  setError() {
    setViewSate(ViewState.error);
  }

  setEmpty() {
    setViewSate(ViewState.empty);
  }

  setFirst() {
    setViewSate(ViewState.first);
  }

  setContent() {
    setViewSate(ViewState.content);
  }


  onError() {
     if (viewState == ViewState.first) {
        setError();
      }
  }

  retry() {
    setFirst();
  }

  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }
}
