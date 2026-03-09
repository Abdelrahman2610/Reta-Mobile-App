import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/widgets/coming_soon_bottom_sheet.dart';
import 'package:reta/features/auth/presentation/pages/settings_page.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_cubit.dart';
import 'package:reta/features/payment/presentations/pages/my_payment_page.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/helpers/runtime_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../declarations/presentations/pages/declarations_page.dart';
import '../../data/models/user_models.dart';
import '../cubit/home_cubit.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/user_profile_cubit.dart';
import 'guest_page.dart';
import 'home_tab.dart';
import 'login_page.dart';
import 'signup_page.dart';

class MainPage extends StatelessWidget {
  final bool isLoggedIn;
  final UserModel? user;

  const MainPage({super.key, this.isLoggedIn = false, this.user});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    if (!isLoggedIn) {
      return const GuestPage();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => NotificationsCubit()),
        BlocProvider(create: (_) => UserProfileCubit()..loadFromUser(user)),
        BlocProvider(create: (_) => DeclarationCubit()..fetchList()),
      ],
      child: _MainView(user: user ?? UserModel.guest()),
    );
  }
}

class _MainView extends StatefulWidget {
  final UserModel user;

  const _MainView({required this.user});

  @override
  State<_MainView> createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutralLightLight,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: PersistentTabView(
              navBarHeight: 84.h,
              context,
              controller: context.read<HomeCubit>().mainScreenTabController,
              screens: [
                // index 0 — الرئيسية
                HomeTab(user: widget.user),

                // index 1 — مديونياتي
                const SizedBox(),

                // index 2 — إقراراتي
                DeclarationsPage(),

                // index 3 — مدفوعاتي
                MyPaymentPage(),

                // index 4 — الإعدادات
                SettingsPage(currentUser: widget.user),
              ],
              items: navBarItems(
                context.read<HomeCubit>().mainScreenTabController.index,
              ),
              onItemSelected: (int index) {
                context.read<HomeCubit>().selectTab(index);
              },
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              animationSettings: const NavBarAnimationSettings(
                navBarItemAnimation: ItemAnimationSettings(
                  duration: Duration(milliseconds: 200),
                ),
                screenTransitionAnimation: ScreenTransitionAnimationSettings(
                  animateTabTransition: true,
                ),
              ),
              navBarStyle: NavBarStyle.style2,
            ),
          ),
        );
      },
    );
  }

  List<PersistentBottomNavBarItem> navBarItems(int selectedIndex) {
    return [
      item(
        FixedAssets.instance.unselectedHome,
        FixedAssets.instance.selectedHome,
        "الرئيسية",
        checkIsNavBarSelected(0, selectedIndex),
      ),
      item(
        FixedAssets.instance.unselectedDebt,
        FixedAssets.instance.selectedDebt,
        "مديونياتي",
        checkIsNavBarSelected(1, selectedIndex),
        isLocked: true,
      ),
      item(
        FixedAssets.instance.declaration,
        FixedAssets.instance.declaration,
        "إقراراتي",
        checkIsNavBarSelected(2, selectedIndex),
        isHome: true,
      ),
      item(
        FixedAssets.instance.unselectedPayment,
        FixedAssets.instance.selectedPayment,
        "مدفوعاتي",
        checkIsNavBarSelected(3, selectedIndex),
        isLocked: false,
      ),
      item(
        FixedAssets.instance.selectedSettings,
        FixedAssets.instance.unselectedSettings,
        "الإعدادات",
        checkIsNavBarSelected(4, selectedIndex),
      ),
    ];
  }

  PersistentBottomNavBarItem item(
    String selectedIcon,
    String unSelectedIcon,
    String title,
    bool isSelected, {
    bool isHome = false,
    bool isLocked = false,
  }) {
    final iconWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageSvgCustomWidget(
          imgPath: isHome || isSelected ? selectedIcon : unSelectedIcon,
          color: isHome
              ? null
              : isSelected
              ? AppColors.mainBlueIndigoDye
              : AppColors.neutralDarkLightest,
          height: isHome ? 44.h : 20.h,
          width: isHome ? 44.w : 24.w,
        ),
        AppText(
          text: title,
          alignment: AlignmentDirectional.center,
          textAlign: TextAlign.center,
          color: isSelected
              ? AppColors.mainBlueSecondary
              : AppColors.neutralDarkLightest,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );

    return PersistentBottomNavBarItem(
      icon: isLocked
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ComingSoonBottomSheet.show(context),
              child: AbsorbPointer(child: iconWidget),
            )
          : iconWidget,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    );
  }

  bool checkIsNavBarSelected(index, selectedIndex) => index == selectedIndex;

  Widget _buildHero() {
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
          onTap: () {
            // TODO: navigate to declarations page
          },
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          onPressed: () {
                            Navigator.of(
                              RuntimeData.getCurrentContext()!,
                            ).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
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
                          onPressed: () {
                            Navigator.of(
                              RuntimeData.getCurrentContext()!,
                            ).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const SignupPage(),
                              ),
                              (route) => false,
                            );
                          },
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
