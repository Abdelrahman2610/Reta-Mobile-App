import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/helpers/runtime_data.dart';
import 'package:reta/features/auth/presentation/pages/main_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_models.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'package:reta/core/widgets/authenticated_settings_content.dart';
import 'help_support_page.dart';
import 'terms_privacy_page.dart';
import 'guest_page.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  final UserModel currentUser;

  const SettingsPage({super.key, required this.currentUser});

  factory SettingsPage.forGuest() {
    return SettingsPage(currentUser: UserModel.guest());
  }

  factory SettingsPage.forUser(UserModel user) {
    return SettingsPage(currentUser: user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(initialUser: currentUser)..loadSettings(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: AppBar(
          backgroundColor: AppColors.mainBlueIndigoDye,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'الإعدادات',
            style: AppTextStyles.actionXL.copyWith(
              color: AppColors.neutralLightLightest,
            ),
          ),
        ),
        body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SettingsLoaded) {
              return _buildBody(context, state);
            }
            if (state is SettingsError) {
              return _ErrorView(message: state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SettingsLoaded state) {
    switch (state.user.userType) {
      case UserType.guest:
        return const _GuestSettingsContent();

      case UserType.authenticated:
        return AuthenticatedSettingsContent(
          user: state.user,
          currentLanguage: state.currentLanguage,
        );
    }
  }

  void _handleStateChanges(BuildContext context, SettingsState state) {
    if (state is SettingsLoggedOut || state is SettingsAccountDeleted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainPage(isLoggedIn: false)),
        (route) => false,
      );
    }
    if (state is SettingsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorDark,
        ),
      );
    }
  }
}

class _GuestSettingsContent extends StatelessWidget {
  const _GuestSettingsContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 32),

          _buildSectionLabel('الدعم والمعلومات'),
          const SizedBox(height: 8),
          _buildSettingsCard(context, [
            _SettingItem(
              icon: Icons.help_outline,
              label: 'المساعدة والدعم',
              onTap: () {
                Navigator.of(RuntimeData.getCurrentContext()!).push(
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                );
              },
            ),
            _SettingItem(
              icon: Icons.privacy_tip_outlined,
              label: 'الشروط والخصوصية',
              onTap: () {
                Navigator.of(RuntimeData.getCurrentContext()!).push(
                  MaterialPageRoute(builder: (_) => const TermsPrivacyPage()),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),
          _buildSectionLabel('إجراءات الحساب'),
          const SizedBox(height: 8),
          _buildSettingsCard(context, [
            _SettingItem(
              icon: Icons.login_outlined,
              label: 'تسجيل الدخول',
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.actionM.copyWith(
          color: AppColors.neutralDarkLight,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<_SettingItem> items) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neutralLightLightest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      item.icon,
                      color: item.isDestructive
                          ? AppColors.errorDark
                          : AppColors.highlightDarkest,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.actionL.copyWith(
                          color: item.isDestructive
                              ? AppColors.errorDark
                              : AppColors.neutralDarkDarkest,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: item.isDestructive
                          ? AppColors.errorDark.withOpacity(0.4)
                          : AppColors.neutralLightDark,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.errorDark),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLight,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<SettingsCubit>().loadSettings(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
