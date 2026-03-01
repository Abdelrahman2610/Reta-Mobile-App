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

/// Authenticated settings tab — uses a nested Navigator so that pages pushed
/// within the settings flow keep the bottom navbar visible.
///
/// THE BUG: The nested Navigator creates a brand-new route scope that lives
/// OUTSIDE the MultiBlocProvider in MainPage. Any widget inside it that calls
/// context.read<NotificationsCubit>() (or any other cubit) gets a
/// ProviderNotFoundException because it can't look up the tree past the
/// Navigator boundary.
///
/// THE FIX: Capture the existing cubit instances from the parent context
/// BEFORE entering the nested Navigator, then re-inject them with
/// BlocProvider.value() inside. Using .value() is critical — it shares the
/// SAME instance (same state) rather than creating new ones.
class SettingsTab extends StatelessWidget {
  final UserModel user;

  const SettingsTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Read cubits here — this context IS inside MultiBlocProvider
    final notificationsCubit = context.read<NotificationsCubit>();
    final homeCubit = context.read<HomeCubit>();

    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          // .value() = same instance, shared state, no double-initialization
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
