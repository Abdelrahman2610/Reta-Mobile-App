import 'package:flutter/material.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../components/app_container.dart';
import '../../../declarations/presentations/components/declaration_data_tab.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    this.currentStep = 1,
    this.onFirstStepTapped,
    this.onSecondStepTapped,
  });

  final int? currentStep;
  final VoidCallback? onFirstStepTapped;
  final VoidCallback? onSecondStepTapped;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      boxShadow: [],
      child: Column(
        children: [
          Row(
            children: [
              DeclarationDataTab(
                declarationsType: DeclarationsDataType.payInfo,
                isSelected: currentStep == 1 ? true : false,
                isFinished: false,
                onTap: onFirstStepTapped,
              ),
              DeclarationDataTab(
                declarationsType: DeclarationsDataType.paymentRequests,
                isSelected: currentStep == 1 ? false : true,
                isFinished: false,
                onTap: onSecondStepTapped,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
