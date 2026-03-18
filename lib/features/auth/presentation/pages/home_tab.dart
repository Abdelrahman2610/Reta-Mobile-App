import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_states.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../declarations/presentations/components/declarations_card_item.dart';
import '../../data/models/user_models.dart';
import '../cubit/home_cubit.dart';
import '../cubit/notifications_cubit.dart';
import 'declaration_summary.dart';
import 'guest_declarations_page.dart';
import 'notifications_page.dart';

class HomeTab extends StatelessWidget {
  final UserModel user;

  const HomeTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightLight,
      body: RefreshIndicator(
        onRefresh: () => context.read<DeclarationCubit>().fetchList(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _HomeHero(user: user),
                Positioned(
                  bottom: -66,
                  left: 16,
                  right: 16,
                  child: _HeroCard(),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DeclarationsSection(user: user),
                    const SizedBox(height: 16),
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

class _HomeHero extends StatelessWidget {
  final UserModel user;

  const _HomeHero({required this.user});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء النور';
  }

  // Returns full name
  String get _displayName =>
      '${user.firstname ?? ''} ${user.lastname ?? ''}'.trim();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, notifState) {
        final unreadCount = notifState.unreadCount;

        return SizedBox(
          width: double.infinity,
          height: 260,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: AppColors.mainDarkBlue)),
              Positioned.fill(
                child: Image.asset(
                  'assets/images/home_bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: AppColors.mainBlueSecondary.withOpacity(0.52),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mainBlueIndigoDye.withOpacity(0.47),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _greeting,
                              textDirection: TextDirection.rtl,
                              style: AppTextStyles.bodyL.copyWith(
                                color: AppColors.highlightLightest,
                              ),
                            ),
                            Text(
                              _displayName,
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
                          count: unreadCount,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<NotificationsCubit>(),
                                child: const NotificationsPage(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainDarkBlue.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: AppColors.mainDarkBlue)),
            Positioned.fill(
              child: Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                color: AppColors.mainBlueSecondary.withOpacity(0.9),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.mainBlueIndigoDye.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'مصلحة الضرائب العقارية',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.actionXXL.copyWith(
                      color: AppColors.highlightLightest,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeclarationsSection extends StatelessWidget {
  final UserModel user;
  const _DeclarationsSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeclarationCubit, DeclarationState>(
      builder: (context, state) {
        if (state is! DeclarationListLoading &&
            state is! DeclarationListError &&
            state is DeclarationListLoaded &&
            (state.declarationList?.isEmpty ?? true)) {
          return _NewUserCTA(
            onTap: () {
              context.read<HomeCubit>().selectTab(2);
            },

            //   Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => GuestDeclarationsPage(user: user),
            //   ),
            // ),
          );
        }

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
                  style: AppTextStyles.h4.copyWith(
                    color: const Color(0xFF005FAD),
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<HomeCubit>().jumpTo(2),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'عرض الكل',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.highlightDarkest,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.highlightDarkest,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (state is DeclarationListLoading)
              _DeclarationsLoading()
            else if (state is DeclarationListError)
              _DeclarationsError(
                message: state.message,
                onRetry: () => context.read<DeclarationCubit>().fetchList(),
              )
            else if (state is DeclarationListLoaded)
              SizedBox(
                height: 300.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  itemCount: state.declarationList!.length > 3
                      ? 3
                      : state.declarationList!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => Column(
                    children: [
                      SizedBox(
                        width: .7.sw,
                        child: DeclarationsCardItem(
                          item: state.declarationList![i],
                          updateDeclarationList: () {
                            context.read<DeclarationCubit>().fetchList();
                          },
                          onDeclarationCardTapped: () => context
                              .read<DeclarationCubit>()
                              .onDeclarationCardTapped(
                                state.declarationList![i],
                                context: context,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NewUserCTA extends StatelessWidget {
  final VoidCallback onTap;

  const _NewUserCTA({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: AppColors.warningDark,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFFF8F9FE),
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    color: AppColors.warningDark,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تقديم الإقرار الضريبي',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.neutralLightLightest,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'قدّم إقرارًا موحّدًا لجميع ممتلكاتك العقارية، مع إمكانية إضافة أكثر من عقار قبل الإرسال.',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.neutralLightLightest.withOpacity(
                            0.90,
                          ),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.neutralLightLightest,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeclarationCard extends StatelessWidget {
  final DeclarationSummary declaration;

  const _DeclarationCard({required this.declaration});

  String get _formattedDate {
    final d = declaration.submittedAt;
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Color get _badgeColor {
    switch (declaration.status) {
      case DeclarationStatus.draft:
        return const Color(0xFF8F9098);
      case DeclarationStatus.submitted:
        return AppColors.errorMedium;
      case DeclarationStatus.approved:
        return AppColors.successMedium;
      case DeclarationStatus.rejected:
        return AppColors.errorMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4D6DD), width: 0.5),
        gradient: const LinearGradient(
          transform: GradientRotation(140 * 3.1415926535 / 180),
          stops: [0.4663, 1.0],
          colors: [Color(0x33FFFFFF), Color(0x336FBAFF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إقرار عام',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyS.copyWith(
                  color: AppColors.mainBlueIndigoDye,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _StatusBadge(label: declaration.status.label, color: _badgeColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: _InfoBox(
                  label: 'صفة مقدم الطلب',
                  value: declaration.ownerName,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _InfoBox(
                  label: 'رقم الإقرار',
                  value: declaration.declarationNumber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: _InfoBox(label: 'آخر تحديث', value: _formattedDate),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _InfoBox(
                  label: 'عدد الوحدات',
                  value: declaration.unitCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(DeclarationStatus s) {
    switch (s) {
      case DeclarationStatus.draft:
        return const Color(0xFF8F9098);
      case DeclarationStatus.submitted:
        return AppColors.successMedium;
      case DeclarationStatus.approved:
        return AppColors.errorMedium;
      case DeclarationStatus.rejected:
        return AppColors.errorDark;
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
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.actionS.copyWith(
          color: AppColors.neutralLightLightest,
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
          label,
          style: AppTextStyles.captionM.copyWith(
            color: AppColors.neutralDarkLight,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.captionM.copyWith(
            color: AppColors.neutralDarkDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xB3FFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD4D6DD), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textDirection: TextDirection.rtl,
            style: AppTextStyles.captionM.copyWith(
              color: AppColors.neutralDarkLight,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textDirection: TextDirection.rtl,
            style: AppTextStyles.captionM.copyWith(
              color: AppColors.neutralDarkDark,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DeclarationsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: AppColors.neutralLightDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SizedBox(width: .7.sw, height: 230.h),
            ),
          ],
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

class _QuickActionCard extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final String subtitle;
  final int badgeCount;
  final VoidCallback onTap;

  const _QuickActionCard({
    this.icon,
    this.imagePath,
    required this.title,
    required this.subtitle,
    required this.badgeCount,
    required this.onTap,
  }) : assert(
         icon != null || imagePath != null,
         'Provide either icon or imagePath',
       );

  @override
  Widget build(BuildContext context) {
    final bool hasItems = badgeCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warningDark),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.neutralLightLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildIconWidget(),
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
                          color: AppColors.neutralDarkDarkest,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.neutralDarkLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasItems) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: AppTextStyles.captionM.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWidget() {
    if (imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(
          imagePath!,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      );
    }
    return Icon(icon, color: AppColors.warningDark, size: 24);
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
        Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            color: AppColors.neutralLightMedium,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(icon, color: AppColors.highlightDarkest, size: 30),
            onPressed: onTap,
          ),
        ),
        if (count > 0)
          Positioned(
            bottom: -8,
            right: -12,
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: AppColors.errorDark,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: AppTextStyles.actionM.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
