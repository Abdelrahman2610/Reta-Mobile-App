import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/widgets/settings_toggle_tile.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/cubit/notifications_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/settings_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/home_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/auth/presentation/pages/user_profile_page.dart';
import 'package:reta/features/auth/presentation/pages/help_support_page.dart';
import 'package:reta/features/auth/presentation/pages/terms_privacy_page.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_state.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';
import 'user_profile_header.dart';
import 'settings_tile.dart';
import 'confirmation_dialog.dart';

class AuthenticatedSettingsContent extends StatelessWidget {
  final UserModel user;
  final String currentLanguage;

  const AuthenticatedSettingsContent({
    super.key,
    required this.user,
    required this.currentLanguage,
  });

  void _pushWithCubits(BuildContext context, Widget page) {
    final notificationsCubit = context.read<NotificationsCubit>();
    final homeCubit = context.read<HomeCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    final userProfileCubit = context.read<UserProfileCubit>();

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: notificationsCubit),
                BlocProvider.value(value: homeCubit),
                BlocProvider.value(value: settingsCubit),
                BlocProvider.value(value: userProfileCubit),
              ],
              child: page,
            ),
          ),
        )
        .then((_) {
          userProfileCubit.loadFromUser(null);
        });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, notifState) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),

            BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                final liveUser = state is UserProfileLoaded
                    ? state.userModel
                    : user;
                return UserProfileHeader(user: liveUser);
              },
            ),

            const SizedBox(height: 16),

            SettingsTile(
              icon: Icons.person_outline,
              label: 'بيانات المستخدم',
              onTap: () => _pushWithCubits(context, UserProfilePage()),
            ),

            _SectionLabel('الإعدادات العامة'),
            const SizedBox(height: 8),
            SettingsToggleTile(
              icon: Icons.notifications_none_outlined,
              label: 'تفعيل الإشعارات',
              value: notifState.notificationsEnabled,
              onChanged: (val) => context
                  .read<NotificationsCubit>()
                  .setNotificationsEnabled(val),
            ),
            const SizedBox(height: 16),

            _SectionLabel('الدعم والمعلومات'),
            const SizedBox(height: 8),
            SettingsTile(
              icon: Icons.help_outline,
              label: 'المساعدة والدعم',
              onTap: () => _pushWithCubits(context, const HelpSupportPage()),
            ),
            SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: 'الشروط والخصوصية',
              onTap: () => _pushWithCubits(context, const TermsPrivacyPage()),
            ),

            const SizedBox(height: 16),

            _SectionLabel('إجراءات الحساب'),
            const SizedBox(height: 8),
            SettingsTile(
              icon: Icons.logout_outlined,
              label: 'تسجيل الخروج',
              isDestructive: false,
              onTap: () => _handleLogout(context, cubit),
            ),
            SettingsTile(
              icon: Icons.delete_outline,
              label: 'حذف الحساب',
              isDestructive: true,
              onTap: () => _handleDeleteAccount(context, cubit),
            ),

            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context, SettingsCubit cubit) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'تسجيل الخروج',
      message:
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟ ستحتاج إلى تسجيل الدخول مرة أخرى لاستخدام التطبيق.',
      confirmLabel: 'خروج',
      isDestructive: false,
    );
    if (confirmed) {
      await cubit.logout();
    }
  }

  Future<void> _handleDeleteAccount(
    BuildContext context,
    SettingsCubit cubit,
  ) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'تأكيد حذف الحساب',
      message:
          'هل أنت متأكد من رغبتك في حذف حسابك نهائيًا من تطبيق مصلحة الضرائب العقارية؟',
      confirmLabel: 'حذف الحساب نهائيًا',
      isDestructive: true,
    );
    if (confirmed) {
      await cubit.deleteAccount();
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.actionM.copyWith(
          color: AppColors.neutralDarkLight,
        ),
      ),
    );
  }
}
