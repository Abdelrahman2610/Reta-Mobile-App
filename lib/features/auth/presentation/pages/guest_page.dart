import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../cubit/guest_cubit.dart';
import 'auth_gate_dialog.dart';
import 'guest_declarations_page.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'signup_page.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return BlocProvider(create: (_) => GuestCubit(), child: const _GuestView());
  }
}

class _GuestView extends StatelessWidget {
  const _GuestView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestCubit, GuestState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutralLightLight,
          body: IndexedStack(
            index: state.selectedIndex,
            children: [
              _HomeTab(),
              const _ProtectedTab(label: 'مديونياتي'),
              const GuestDeclarationsPage(),
              const _ProtectedTab(label: 'مدفوعاتي'),
              const SettingsPage(),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: state.selectedIndex,
            items: AppNavItems.guest,
            onItemSelected: (index) {
              if (index == 1 || index == 3) {
                showAuthGateDialog(
                  context,
                  title: 'الدخول إلى الحساب',
                  message:
                      'يرجى تسجيل الدخول أو إنشاء حساب جديد للاستمرار والاستفادة من خدمات مصلحة الضرائب العقارية.',
                );
              } else {
                context.read<GuestCubit>().selectTab(index);
              }
            },
          ),
        );
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHero(context),
        Expanded(
          child: Container(
            color: AppColors.neutralLightLight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                children: [
                  _buildDeclarationCard(context),
                  const SizedBox(height: 16),
                  _buildAuthCard(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.mainBlueIndigoDye,
                BlendMode.hue,
              ),
              child: Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.mainBlueIndigoDye.withOpacity(0.88),
                    AppColors.mainBlueSecondary.withOpacity(0.88),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.highlightLight.withOpacity(0.20),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset('assets/images/logo.svg'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'مصلحة الضرائب العقارية',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.highlightLightest,
                        fontSize: 28,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'مرحبًا بك في خدمات مصلحة الضرائب العقارية',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.bodyXL.copyWith(
                        color: AppColors.highlightLightest.withOpacity(0.82),
                        height: 1.4,
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
  }

  Widget _buildDeclarationCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warningDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.warningDark.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.read<GuestCubit>().selectTab(2),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        'قدم إقراراً موحداً لجميع ممتلكاتك العقارية، مع إمكانية إضافة أكثر من عقار قبل الإرسال.',
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
                  Icons.arrow_back_ios_rounded,
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

  Widget _buildAuthCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralLightDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 70,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'للاستفادة من خدمات التطبيق',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.mainBlueIndigoDye,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'يرجى تسجيل الدخول أو إنشاء حساب جديد لتقديم الإقرار الضريبي وإدارة ممتلكاتك العقارية.',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.neutralDarkLight,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.highlightDarkest,
                            foregroundColor: AppColors.neutralLightLightest,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.actionM.copyWith(
                              color: AppColors.neutralLightLightest,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignupPage(),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.highlightDarkest,
                            side: const BorderSide(
                              color: AppColors.highlightDarkest,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'إنشاء حساب جديد',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.actionM.copyWith(
                              color: AppColors.highlightDarkest,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtectedTab extends StatelessWidget {
  final String label;
  const _ProtectedTab({required this.label});

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
