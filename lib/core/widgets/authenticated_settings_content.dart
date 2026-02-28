import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/cubit/settings_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/settings_state.dart';
import 'package:reta/features/auth/presentation/pages/user_profile_page.dart';
import 'package:reta/features/auth/presentation/pages/help_support_page.dart';
import 'package:reta/features/auth/presentation/pages/terms_privacy_page.dart';

import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';
import 'user_profile_header.dart';
import 'settings_tile.dart';
import 'settings_toggle_tile.dart';
import 'language_picker_sheet.dart';
import 'confirmation_dialog.dart';

class AuthenticatedSettingsContent extends StatefulWidget {
  final UserModel user;
  final String currentLanguage;

  const AuthenticatedSettingsContent({
    super.key,
    required this.user,
    required this.currentLanguage,
  });

  @override
  State<AuthenticatedSettingsContent> createState() =>
      _AuthenticatedSettingsContentState();
}

class _AuthenticatedSettingsContentState
    extends State<AuthenticatedSettingsContent> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),

        UserProfileHeader(user: widget.user),

        const SizedBox(height: 16),

        SettingsTile(
          icon: Icons.person_outline,
          label: 'بيانات المستخدم',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserProfilePage(user: widget.user),
              ),
            );
          },
        ),

        _SectionLabel('الإعدادات العامة'),
        const SizedBox(height: 8),
        SettingsToggleTile(
          icon: Icons.notifications_none_outlined,
          label: 'إيقاف الإشعارات',
          value: _notificationsEnabled,
          onChanged: (val) => setState(() => _notificationsEnabled = val),
        ),

        const SizedBox(height: 16),

        _SectionLabel('الدعم والمعلومات'),
        const SizedBox(height: 8),
        SettingsTile(
          icon: Icons.help_outline,
          label: 'المساعدة والدعم',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const HelpSupportPage()));
          },
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'الشروط والخصوصية',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TermsPrivacyPage()));
          },
        ),

        const SizedBox(height: 16),

        // _SectionLabel('التفضيلات'),
        // const SizedBox(height: 8),
        // SettingsTile(
        //   icon: Icons.language_outlined,
        //   label: widget.currentLanguage == 'ar' ? 'اللغة: عربي' : 'Language: English',
        //   onTap: () async {
        //     final selected = await showLanguagePickerSheet(
        //       context,
        //       currentLanguage: widget.currentLanguage,
        //     );
        //     if (selected != null) {
        //       cubit.changeLanguage(selected);
        //     }
        //   },
        //   trailing: Text(
        //     widget.currentLanguage == 'ar' ? 'عربي' : 'English',
        //     style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
        //   ),
        // ),
        // const SizedBox(height: 24),
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
