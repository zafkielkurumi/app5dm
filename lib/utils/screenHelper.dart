import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class Screen {
  static MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
  static num setWidth(double size) {
    return ScreenUtil().setWidth(size);
  }

  static num setHeight(double size) {
    return ScreenUtil().setWidth(size);
  }

  static num setSp(double size) {
    return ScreenUtil().setWidth(size);
  }

  static num get screenWidth => ScreenUtil.screenWidth;
 
 static double get width => mediaQueryData.size.width;
 static double get height => mediaQueryData.size.height;
 static double get statusHeight => mediaQueryData.padding.top;
 static double get keyBoardHeight => mediaQueryData.viewInsets.bottom;
}