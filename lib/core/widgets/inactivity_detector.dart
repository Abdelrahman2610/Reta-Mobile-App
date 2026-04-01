import 'package:flutter/material.dart';
import '../services/inactivity_service.dart';

class InactivityDetector extends StatelessWidget {
  final Widget child;
  const InactivityDetector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => InactivityService().onUserActivity(),
      onPointerMove: (_) => InactivityService().onUserActivity(),
      onPointerUp: (_) => InactivityService().onUserActivity(),
      child: child,
    );
  }
}
