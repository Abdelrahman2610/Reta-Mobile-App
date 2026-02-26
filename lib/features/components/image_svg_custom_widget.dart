import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///For SVG Images
class ImageSvgCustomWidget extends StatelessWidget {
  const ImageSvgCustomWidget({
    super.key,
    this.imgPath,
    this.height,
    this.imageFit = BoxFit.contain,
    this.width,
    this.isFromAssets = true,
    this.color,
  });

  final double? width;
  final double? height;
  final BoxFit imageFit;
  final String? imgPath;
  final Color? color;
  final bool isFromAssets;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isFromAssets
          ? SvgPicture.asset(
              imgPath!,
              fit: imageFit,
              color: color,
              height: height,
              width: width,
            )
          : SvgPicture.network(
              imgPath!,
              color: color,
              fit: imageFit,
              height: height,
              width: width,
            ),
    );
  }
}
