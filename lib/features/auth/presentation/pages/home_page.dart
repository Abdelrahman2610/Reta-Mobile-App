import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../cubit/home_cubit.dart';
import 'home_tab.dart';
import 'placeholder_tabs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return BlocProvider(create: (_) => HomeCubit(), child: const _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutralLightLight,
          body: IndexedStack(
            index: state.selectedIndex,
            children: const [
              HomeTab(),
              DebtsTab(),
              DeclarationsTab(),
              PaymentsTab(),
              SettingsTab(),
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
