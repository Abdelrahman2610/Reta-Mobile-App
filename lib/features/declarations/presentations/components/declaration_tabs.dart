import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/provider_data_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import 'declaration_data_tab.dart';

class DeclarationTabs extends StatelessWidget {
  const DeclarationTabs({super.key, required this.applicantType});

  final ApplicantType applicantType;

  @override
  Widget build(BuildContext context) {
    return applicantType == ApplicantType.owner ||
            applicantType == ApplicantType.beneficiary ||
            applicantType == ApplicantType.exploited
        ? AppContainer(
            height: 93,
            child: AppText(
              text: DeclarationsDataType.providerData.displayText,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              color: AppColors.neutralDarkDarkest,
              alignment: AlignmentDirectional.center,
            ),
          )
        : AppContainer(
            height: 93,
            child: Row(
              children: [
                DeclarationDataTab(
                  declarationsType: DeclarationsDataType.providerData,
                  isSelected: false,
                  isFinished: true,
                ),
                DeclarationDataTab(
                  declarationsType: DeclarationsDataType.taxpayerData,
                  isSelected: true,
                  isFinished: false,
                ),
              ],
            ),
          );
  }
}
