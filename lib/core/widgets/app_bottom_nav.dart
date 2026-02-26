import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppNavItem {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final int index;
  final bool isFeatured;

  const AppNavItem({
    this.icon,
    this.imagePath,
    required this.label,
    required this.index,
    this.isFeatured = false,
  }) : assert(
         icon != null || imagePath != null,
         'AppNavItem needs either icon or imagePath',
       );
}

abstract class AppNavItems {
  static const List<AppNavItem> guest = [
    AppNavItem(icon: Icons.home_filled, label: 'الرئيسية', index: 0),
    AppNavItem(
      imagePath: 'assets/images/debts.png',
      label: 'مديونياتي',
      index: 1,
    ),
    AppNavItem(
      icon: Icons.article_outlined,
      label: 'إقراراتي',
      index: 2,
      isFeatured: true,
    ),
    AppNavItem(
      imagePath: 'assets/images/payment.png',
      label: 'مدفوعاتي',
      index: 3,
    ),
    AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات', index: 4),
  ];

  static const List<AppNavItem> authenticated = [
    AppNavItem(icon: Icons.home_filled, label: 'الرئيسية', index: 0),
    AppNavItem(
      imagePath: 'assets/images/debts.png',
      label: 'مديونياتي',
      index: 1,
    ),
    AppNavItem(
      icon: Icons.article_outlined,
      label: 'إقراراتي',
      index: 2,
      isFeatured: true,
    ),
    AppNavItem(
      imagePath: 'assets/images/payment.png',
      label: 'مدفوعاتي',
      index: 3,
    ),
    AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات', index: 4),
  ];
}

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final List<AppNavItem> items;
  final ValueChanged<int> onItemSelected;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.mainBlueSecondary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            textDirection: TextDirection.rtl,
            children: items
                .map(
                  (item) => _AppNavItemTile(
                    item: item,
                    isSelected: selectedIndex == item.index,
                    onTap: () => onItemSelected(item.index),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _AppNavItemTile extends StatelessWidget {
  final AppNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppNavItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return item.isFeatured ? _featured() : _regular();
  }

  Widget _featured() {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.mainOrange,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.mainOrange,
                          spreadRadius: 3,
                          blurRadius: 6,
                        ),
                      ]
                    : [],
              ),
              child: Icon(item.icon, color: AppColors.white, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTextStyles.captionM.copyWith(
                color: isSelected
                    ? AppColors.mainBlueIndigoDye
                    : AppColors.mainBlueSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _regular() {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.imagePath != null
                ? Image.asset(
                    item.imagePath!,
                    width: 22,
                    height: 22,
                    color: isSelected
                        ? AppColors.mainBlueSecondary
                        : AppColors.neutralDarkLightest,
                  )
                : Icon(
                    item.icon,
                    color: isSelected
                        ? AppColors.mainBlueIndigoDye
                        : AppColors.neutralDarkLightest,
                    size: 22,
                  ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: AppTextStyles.captionM.copyWith(
                color: isSelected
                    ? AppColors.mainBlueSecondary
                    : AppColors.neutralDarkLightest,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 20 : 0,
              decoration: BoxDecoration(
                color: AppColors.mainBlueIndigoDye,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
