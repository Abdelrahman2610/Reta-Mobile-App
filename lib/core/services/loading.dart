import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingService {
  bool _isShowing = false;

  void showLoading(BuildContext context) {
    if (_isShowing) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: () => hideLoading(context),
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: SpinKitPulse(color: Colors.white, size: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> hideLoading(BuildContext context) async {
    log('MSG: isShowing: $_isShowing');
    if (!_isShowing) return;

    _isShowing = false;

    if (Navigator.canPop(context)) ;
    Navigator.of(context, rootNavigator: true).pop();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
