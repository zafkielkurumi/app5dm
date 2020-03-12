
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

getFunction(BuildContext context, T) {
  // return Provider.of<T>(context);
  // Consumer
}

 class BaseProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.first;
  bool _dispose = false;
  String errorMessage = '';

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
       debugPrint(e.toString());
        if (e.type  == DioErrorType.RESPONSE && e.response.statusCode == 503) {
          errorMessage = '503问题，暂未解决';
        }
        if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
           errorMessage = '网络连接超时';
        }
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
