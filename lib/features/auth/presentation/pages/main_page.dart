import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/widgets/coming_soon_bottom_sheet.dart';
import 'package:reta/features/auth/presentation/pages/settings_page.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_cubit.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../declarations/presentations/pages/declarations_page.dart';
import '../../data/models/user_models.dart';
import '../cubit/home_cubit.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/user_profile_cubit.dart';
import 'guest_page.dart';
import 'home_tab.dart';

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
                const SizedBox(),

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
        isLocked: true,
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
}
