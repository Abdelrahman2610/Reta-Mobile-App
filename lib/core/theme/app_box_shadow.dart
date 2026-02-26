import 'package:flutter/material.dart';

class AppBoxShadow {
  AppBoxShadow._privateConstructor();
  static final AppBoxShadow _instance = AppBoxShadow._privateConstructor();

  static AppBoxShadow get instance => _instance;

  List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black12, offset: Offset(1, 5), blurRadius: 5),
  ];
}
