import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:reta/features/auth/presentation/cubit/notifications_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration_lookups_cubit.dart';
import 'package:reta/features/splash/presentation/pages/splash.dart';

import 'core/helpers/runtime_data.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  await initializeDateFormatting('ar');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DeclarationLookupsCubit()),
          BlocProvider(create: (_) => DeclarationCubit()),
          BlocProvider(create: (_) => NotificationsCubit()),
          BlocProvider(lazy: true, create: (_) => UserProfileCubit()),
          BlocProvider(lazy: true, create: (_) => UserProfileCubit()),
        ],
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            navigatorKey: RuntimeData.mainAppKey,
            theme: AppTheme.lightTheme,
            // For RTL/LTR support:
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            debugShowCheckedModeBanner: false,
            supportedLocales: const [Locale('ar'), Locale('en')],
            builder: (context, Widget? child) => child!,
            home: SplashPage(),
          ),
        ),
      ),
    );
  }
}
