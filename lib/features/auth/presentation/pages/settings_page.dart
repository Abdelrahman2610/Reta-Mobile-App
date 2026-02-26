import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  final bool isGuest;

  const SettingsPage({super.key, this.isGuest = true});

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

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.neutralLightLightest,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'الإعدادات',
            style: AppTextStyles.actionXL.copyWith(
              color: AppColors.neutralLightLightest,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 32),
              _buildSectionLabel('الدعم والمعلومات'),
              const SizedBox(height: 8),
              _buildSettingsCard([
                _SettingItem(
                  icon: Icons.help_outline,
                  label: 'المساعدة والدعم',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'الشروط والخصوصية',
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionLabel('إجراءات الحساب'),
              const SizedBox(height: 8),
              if (isGuest) ...[
                _buildSettingsCard([
                  _SettingItem(
                    icon: Icons.login_outlined,
                    label: 'تسجيل الدخول',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                ]),
              ] else ...[
                _buildSettingsCard([
                  _SettingItem(
                    icon: Icons.logout_outlined,
                    label: 'تسجيل الخروج',
                    onTap: () {
                      // TODO: dispatch logout event
                    },
                    isDestructive: true,
                  ),
                ]),
              ],
            ],
          ),
        ),
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

  Widget _buildSettingsCard(List<_SettingItem> items) {
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
