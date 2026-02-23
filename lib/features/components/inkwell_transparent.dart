import 'package:flutter/material.dart';

class InkwellTransparent extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const InkwellTransparent({
    required this.onTap,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: child,
    );
  }
}
