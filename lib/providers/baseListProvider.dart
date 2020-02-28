import 'package:flutter/material.dart';

import './baseProvider.dart';

class BaseListProvider extends BaseProvider {
  bool haseMore = true;
  int page = 1;
  ScrollController controller;
}