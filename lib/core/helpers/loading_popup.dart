import 'package:flutter/material.dart';

import '../../features/components/circular_progress_indicator_platform_widget.dart';

loadingPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicatorPlatformWidget()),
      );
    },
  );
}
