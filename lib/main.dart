import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/auth/presentation/pages/guest_page.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/presentation/pages/splash.dart';

void main() {
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
      child: MaterialApp(
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
        // home: MainPage(),
        routes: {'/home': (context) => GuestPage()},
      ),
    );
  }
}
