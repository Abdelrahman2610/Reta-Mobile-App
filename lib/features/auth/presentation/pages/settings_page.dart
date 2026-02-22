import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightLightest,
      appBar: AppBar(
        backgroundColor: AppColors.mainBlueIndigoDye,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإعدادات',
          style: AppTextStyles.actionXL.copyWith(
            color: AppColors.neutralLightLightest,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.neutralLightLightest,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppColors.neutralLightMedium,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.highlightDarkest,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    bottom: -6,
                    right: -6,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.errorDark,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '9',
                          style: AppTextStyles.captionM.copyWith(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionLabel('الدعم والمعلومات'),
            const SizedBox(height: 8),
            _buildSettingsCard([
              _SettingItem(
                icon: Icons.help_outline,
                label: 'المساعدة والدعم',
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.info,
                label: 'الشروط والخصوصية',
                onTap: () {},
                showDivider: false,
              ),
            ]),

            const SizedBox(height: 24),

            // ── Section: إجراءات الحساب ──
            _buildSectionLabel('إجراءات الحساب'),
            const SizedBox(height: 8),
            _buildSettingsCard([
              _SettingItem(
                icon: Icons.login_outlined,
                label: 'تسجيل الدخول',
                onTap: () {},
                showDivider: false,
              ),
            ]),
          ],
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
        style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
      ),
    );
  }

  Widget _buildSettingsCard(List<_SettingItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutralLightDark),
      ),
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              InkWell(
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
                        color: AppColors.mainBlueIndigoDye,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          textDirection: TextDirection.rtl,
                          style: AppTextStyles.bodyM.copyWith(
                            color: AppColors.neutralDarkDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.neutralDarkLightest,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              if (item.showDivider)
                Divider(
                  height: 1,
                  color: AppColors.neutralLightDark,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });
}
