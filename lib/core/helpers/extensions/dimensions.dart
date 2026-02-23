import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Dimentions on num {
  SizedBox get hs => SizedBox(height: toDouble().h);
  SizedBox get ws => SizedBox(width: toDouble().w);
}
