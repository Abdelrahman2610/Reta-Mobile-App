import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../declarations/presentations/pages/declarations_page.dart';
import '../../data/models/user_models.dart';
import '../cubit/home_cubit.dart';
import '../cubit/notifications_cubit.dart';
import 'guest_page.dart';
import 'home_tab.dart';
import 'placeholder_tabs.dart';

class MainPage extends StatelessWidget {
  final UserModel? user;

  const MainPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    if (user == null) return const GuestPage();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => NotificationsCubit()),
      ],
      child: _AuthenticatedView(user: user!),
    );
  }
}

class _AuthenticatedView extends StatelessWidget {
  final UserModel user;

  const _AuthenticatedView({required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutralLightLight,
          body: IndexedStack(
            index: state.selectedIndex,
            children: [
              HomeTab(user: user),
              const DebtsTab(),
              // const DeclarationsTab(),
              DeclarationsPage(),
              const PaymentsTab(),
              SettingsTab(user: user),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: state.selectedIndex,
            items: AppNavItems.authenticated,
            onItemSelected: (index) =>
                context.read<HomeCubit>().selectTab(index),
          ),
        );
      },
    );
  }
}
