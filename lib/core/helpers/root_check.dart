import 'dart:developer';

import 'package:flutter/services.dart';

class RootCheck {
  static const platform = MethodChannel('root_check');

  static Future<bool> isDeviceRooted() async {
    try {
      final bool result = await platform.invokeMethod('isDeviceRooted');
      return result;
    } on PlatformException catch (e) {
      log("Failed to check root: '${e.message}'.");
      return false;
    }
  }
}
