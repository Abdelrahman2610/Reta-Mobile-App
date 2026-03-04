import 'package:flutter/material.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_button.dart';
import '../../../../../../components/image_svg_custom_widget.dart';

class UnitsAddDeleteButtons extends StatelessWidget {
  const UnitsAddDeleteButtons({
    super.key,
    required this.canDelete,
    this.onAddTapped,
    required this.isLast,
    this.onDeleteTapped,
  });

  final bool canDelete;
  final VoidCallback? onAddTapped;
  final VoidCallback? onDeleteTapped;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isLast)
          Expanded(
            child: AppButton(
              label: 'إضافة إستغلال',
              backgroundColor: AppColors.highlightDarkest,
              icon: Icon(Icons.add, color: AppColors.white),
              iconLeft: false,
              onTap: onAddTapped,
            ),
          )
        else
          SizedBox.shrink(),
        15.ws,
        if (canDelete)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: onDeleteTapped,
              child: ImageSvgCustomWidget(
                imgPath: FixedAssets.instance.deleteIC,
              ),
            ),
          ),
      ],
    );
  }
}
