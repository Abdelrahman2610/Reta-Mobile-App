import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/data/models/user_models.dart';
import '../../../auth/presentation/pages/settings_page.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/home_cubit.dart';

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
  final UserModel user;

  const SettingsTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final notificationsCubit = context.read<NotificationsCubit>();
    final homeCubit = context.read<HomeCubit>();

    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: notificationsCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: SettingsPage(currentUser: user),
        ),
      ),
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
