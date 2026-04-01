import 'dart:async';
import 'package:flutter/material.dart';

class InactivityService {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  static const Duration _timeout = Duration(minutes: 15);
  Timer? _timer;
  VoidCallback? _onTimeout;

  void init(VoidCallback onTimeout) {
    _onTimeout = onTimeout;
    _resetTimer();
  }

  void onUserActivity() {
    if (_onTimeout != null) _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() => _onTimeout?.call();

  void stop() {
    _timer?.cancel();
    _onTimeout = null;
  }
}
