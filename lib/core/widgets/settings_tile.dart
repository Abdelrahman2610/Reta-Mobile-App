import 'package:flutter/material.dart';

import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Widget? trailing;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
    this.trailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = isDestructive
        ? AppColors.errorDark
        : AppColors.highlightDarkest;

    final Color resolvedIconColor = iconColor ?? effectiveColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  icon,
                  textDirection: TextDirection.ltr,
                  color: resolvedIconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.actionL.copyWith(
                      color: isDestructive
                          ? AppColors.neutralDarkDarkest
                          : AppColors.neutralDarkDarkest,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: isDestructive
                          ? AppColors.neutralDarkLightest
                          : AppColors.neutralDarkLightest,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
