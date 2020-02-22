import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum ViewState {
  first, // 默认值，第一次进入显示
  error, // 错误, 重新获取
  empty, // 无数据
  unAuth, // 未登录
  pending, // 请求中
  content,
}

 class BaseProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.first;
  bool _dispose = false;

  ViewState get viewState => _viewState;
  set viewState(value) {
     _viewState = value;
    notifyListeners();
  }



  setUnAuth() {
    viewState = ViewState.unAuth;
  }
  setPending() {
    viewState = ViewState.pending;
  }

  setError() {
    viewState = ViewState.error;
  }

  setEmpty() {
    viewState = ViewState.empty;
  }

  setFirst() {
    viewState = ViewState.first;
  }

  setContent() {
    viewState = ViewState.content;
  }


  onError( e) {
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
