import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/data/models/user_models.dart';
import '../../../auth/presentation/pages/settings_page.dart';

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

/// Authenticated settings tab — uses a nested Navigator so that pages pushed
/// within the settings flow (e.g. UserProfilePage, HelpSupportPage) keep the
/// bottom navbar visible.
class SettingsTab extends StatelessWidget {
  final UserModel user;

  const SettingsTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => SettingsPage(currentUser: user)),
    );
  }
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
