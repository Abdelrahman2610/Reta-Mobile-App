import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'جميع الحقوق محفوظة مصلحة الضرائب العقارية.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.actionM.copyWith(
              color: AppColors.neutralDarkMedium,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'مدعوم بـ',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.actionM.copyWith(
                  color: AppColors.neutralDarkMedium,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/images/etax.svg',
                height: 24,
                placeholderBuilder: (_) =>
                    const SizedBox(width: 60, height: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
