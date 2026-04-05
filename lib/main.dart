import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:reta/features/auth/presentation/cubit/notifications_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration_lookups_cubit.dart';
import 'package:reta/features/splash/presentation/pages/splash.dart';
// import 'core/widgets/inactivity_detector.dart';

import 'core/helpers/runtime_data.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        ],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            navigatorKey: RuntimeData.mainAppKey,
            theme: AppTheme.lightTheme,

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ar'), Locale('en')],
            locale: const Locale('ar'),
            debugShowCheckedModeBanner: false,
            // builder: (context, Widget? child) =>
            //     InactivityDetector(child: child!),
            builder: (context, Widget? child) {
              final mediaQuery = MediaQuery.of(context);
              final clampedTextScale = mediaQuery.textScaleFactor.clamp(
                0.8,
                1.2,
              );
              return MediaQuery(
                data: mediaQuery.copyWith(textScaleFactor: clampedTextScale),
                child: child!,
              );
            },
            home: SplashPage(),
          ),
        ),
      ),
    );
  }
}
