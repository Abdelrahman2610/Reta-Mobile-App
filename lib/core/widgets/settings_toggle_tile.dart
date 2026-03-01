import 'package:flutter/material.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedIconColor = iconColor ?? AppColors.highlightDarkest;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, color: resolvedIconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.actionL.copyWith(
                    color: AppColors.neutralDarkDarkest,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: AppColors.highlightDarkest,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFDDDDDD),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
