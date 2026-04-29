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
      builder: (_) =>
          const Center(child: SpinKitPulse(color: Colors.white, size: 40)),
    );
  }

  Future<void> hideLoading(BuildContext context) async {
    if (!_isShowing) return;

    _isShowing = false;

    Navigator.of(context, rootNavigator: true).pop();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
