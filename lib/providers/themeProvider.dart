import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomThemeModel extends ChangeNotifier {
  CustomThemeModel() {
    changethemeData();
  }

  bool _userDarkMode = false;
  get userDarkMode => _userDarkMode;
  MaterialColor _themeColor = Colors.indigo;

  ThemeData _themeData;
  get themeData => _themeData;

  switchTheme({bool userDarkMode, Color color}) {
    _themeColor = color;
    // _userDarkMode = userDarkMode;
    changethemeData();
    notifyListeners();
  }

  setDarkMode(bool value) {
    _userDarkMode = value;
     SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      );
    switchTheme();
  }

  changethemeData() {
    bool isDark = _userDarkMode;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    var accentColor = isDark ? _themeColor[700] : _themeColor;
    print(brightness);
    print('brightness');
    ThemeData themeData = ThemeData(
      brightness: brightness,
      accentColor: accentColor,
      primarySwatch: _themeColor,
      primaryColor: _themeColor,
      splashColor: _themeColor.withAlpha(50),
      cursorColor: accentColor,
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      // scaffoldBackgroundColor: isDark ?? Colors.grey[200]
    );

    _themeData = themeData.copyWith(
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      buttonTheme: themeData.buttonTheme.copyWith(
        buttonColor: _themeColor,
        textTheme: ButtonTextTheme.primary
      ),
      //  scaffoldBackgroundColor: isDark ? themeData.scaffoldBackgroundColor : Colors.grey[200],
      textTheme: themeData.textTheme.copyWith(
          // 解决中文hint不居中的问题
          subhead: themeData.textTheme.subhead
              .copyWith(textBaseline: TextBaseline.alphabetic)),
    );
  }

  void switchRandomTheme({Brightness brightness}) {
    int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
      userDarkMode: Random().nextBool(),
      color: Colors.primaries[colorIndex],
    );
  }
}
