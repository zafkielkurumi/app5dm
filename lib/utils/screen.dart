import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen {
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
  // static setWidth(double size) {
  //   ScreenUtil().setWidth(size);
  // }
}