import 'package:flutter/material.dart';

class RuntimeData {
  static final GlobalKey<NavigatorState> mainAppKey =
      GlobalKey<NavigatorState>();

  static BuildContext? getCurrentContext() {
    return mainAppKey.currentContext;
  }
}
