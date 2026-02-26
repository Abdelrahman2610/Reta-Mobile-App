import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DebtsTab extends StatelessWidget {
  const DebtsTab({super.key});
  @override
  Widget build(BuildContext context) => _PlaceholderTab(label: 'مديونياتي');
}

class DeclarationsTab extends StatelessWidget {
  const DeclarationsTab({super.key});
  @override
  Widget build(BuildContext context) => _PlaceholderTab(label: 'إقراراتي');
}

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});
  @override
  Widget build(BuildContext context) => _PlaceholderTab(label: 'مدفوعاتي');
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) => _PlaceholderTab(label: 'الإعدادات');
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkLight),
      ),
    );
  }
}
