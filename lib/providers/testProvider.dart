import 'dart:math';

import 'package:app5dm/constants/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './baseProvider.dart';

class TestModel extends BaseProvider {
  TestModel(){
    Future.delayed(Duration(), () {
      setContent();
    });
  }
  String _string1 = 'string1';
  String get  string1 => _string1;
  String string2 = 'string1';
  String test3 = 'string1';
  String test4 = 'string1';
  List testArr = [1, 2];

   List _numberList = [1, 2];
  List get numberList => _numberList;

  double pinHeigt = playerHeight;
  ScrollController sc = ScrollController();

  changePinHeight() {
    pinHeigt = pinHeigt == playerHeight ? kToolbarHeight : playerHeight;
    print(pinHeigt);
    // sc.position.applyContentDimensions(
    //     sc.position.minScrollExtent,
    //     sc.position.maxScrollExtent + pinHeigt);
        notifyListeners();
  }

  changeString1() {
    _string1 = 'string${Random().nextInt(10)}';
    notifyListeners();
  }

  changeString2() {
    print('object');
    string2 = '${Random().nextInt(10)}$string2';
    notifyListeners();
  }

  changeText3() {
    test3 = '${Random().nextInt(10)}$test3';
    notifyListeners();
  }

  changeNumber() {
    numberList.first = Random().nextInt(10);
    debugPrint(numberList.first.toString());
    notifyListeners();
  }
}