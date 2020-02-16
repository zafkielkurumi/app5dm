import 'package:flutter/material.dart';
import 'package:app5dm/constants/Images.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Center(
      child: Image.asset(Images.loading, width: width, fit: BoxFit.fitWidth,),
    );
  }
}