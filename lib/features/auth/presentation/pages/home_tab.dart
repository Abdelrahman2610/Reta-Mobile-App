import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/home_cubit.dart';
import 'declaration_summary.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HomeHero(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refreshDeclarations(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DeclarationsSection(),
                  const SizedBox(height: 16),
                  _QuickActionCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'طلبات السداد',
                    subtitle:
                        'جميع طلبات السداد التي تم إصدارها عند تقديم الإقرار ويمكن سدادها فقط عبر الدفع الإلكتروني أو الإيداع البنكي.',
                    badgeCount: 1,
                    onTap: () {
                      /* TODO: navigate to payment requests */
                    },
                  ),
                  const SizedBox(height: 16),
                  _QuickActionCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'سداد المديونيات',
                    subtitle:
                        'سداد المبالغ المستحقة عن الإقرارات الضريبية المقدمة سابقاً (مديونيات بعلم المكلف).',
                    badgeCount: 2,
                    onTap: () {
                      /* TODO: navigate to debt payment */
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.mainBlueIndigoDye, AppColors.mainBlueSecondary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  _NotificationAvatar(count: 2),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'مساء الخير',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.highlightLightest.withOpacity(0.80),
                        ),
                      ),
                      Text(
                        'أحمد الدسوقي', // TODO: wire from auth state
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.highlightLightest,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _BadgeIconButton(
                    icon: Icons.notifications_outlined,
                    count: 0,
                    onTap: () {
                      // TODO: notifications page
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 44,
                      height: 44,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'مصلحة الضرائب العقارية',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.highlightLightest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeclarationsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إقراراتي',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.mainBlueIndigoDye,
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<HomeCubit>().selectTab(2),
                  child: Text(
                    'عرض الكل',
                    style: AppTextStyles.bodyS.copyWith(
                      color: AppColors.mainBlueSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (state.isLoadingDeclarations)
              _DeclarationsLoading()
            else if (state.errorMessage != null)
              _DeclarationsError(
                message: state.errorMessage!,
                onRetry: () => context.read<HomeCubit>().refreshDeclarations(),
              )
            else if (state.declarations.isEmpty)
              _DeclarationsEmpty()
            else
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  itemCount: state.declarations.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) =>
                      _DeclarationCard(declaration: state.declarations[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DeclarationCard extends StatelessWidget {
  final DeclarationSummary declaration;
  const _DeclarationCard({required this.declaration});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(declaration.status);
    final date = intl.DateFormat(
      'd MMMM yyyy',
      'ar',
    ).format(declaration.submittedAt);

    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutralLightDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(label: declaration.status.label, color: color),
              Text(
                'إقرار عام',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyS.copyWith(
                  color: AppColors.mainBlueIndigoDye,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'صاحب الطلب', value: declaration.ownerName),
          const SizedBox(height: 6),
          _InfoRow(label: 'رقم الإقرار', value: declaration.declarationNumber),
          const SizedBox(height: 6),
          _InfoRow(label: 'أُمر تسديدت', value: date),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'عدد الوحدات',
            value: declaration.unitCount.toString(),
          ),
        ],
      ),
    );
  }

  Color _statusColor(DeclarationStatus s) {
    switch (s) {
      case DeclarationStatus.draft:
        return AppColors.warningDark;
      case DeclarationStatus.submitted:
        return AppColors.mainBlueSecondary;
      case DeclarationStatus.approved:
        return const Color(0xFF27AE60);
      case DeclarationStatus.rejected:
        return const Color(0xFFE74C3C);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionM.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: AppTextStyles.captionM.copyWith(
            color: AppColors.neutralDarkDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.captionM.copyWith(
            color: AppColors.neutralDarkLight,
          ),
        ),
      ],
    );
  }
}

class _DeclarationsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Row(
        children: List.generate(
          2,
          (_) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: AppColors.neutralLightDark,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeclarationsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _DeclarationsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutralLightDark),
      ),
      child: Column(
        children: [
          Text(
            message,
            textDirection: TextDirection.rtl,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.neutralDarkLight,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}

class _DeclarationsEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutralLightDark),
      ),
      child: Text(
        'لا توجد إقرارات حتى الآن',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int badgeCount;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralLightDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.neutralLightLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.mainBlueIndigoDye,
                        size: 24,
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.mainOrange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              badgeCount.toString(),
                              style: AppTextStyles.captionSB.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.mainBlueIndigoDye,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.neutralDarkLight,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.neutralDarkLight,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  final int count;
  const _NotificationAvatar({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.highlightLightest.withOpacity(0.2),
          child: const Icon(
            Icons.person_outline,
            color: AppColors.highlightLightest,
            size: 22,
          ),
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.mainOrange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: AppTextStyles.captionSB.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  const _BadgeIconButton({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: AppColors.highlightLightest, size: 26),
          onPressed: onTap,
        ),
        if (count >= 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: AppColors.errorDark,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: AppTextStyles.captionSB.copyWith(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
