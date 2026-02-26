import 'package:flutter/material.dart';
import 'package:reta/features/splash/presentation/pages/splash.dart';
import 'features/auth/presentation/pages/guest_page.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: SplashPage(),
      routes: {'/home': (context) => GuestPage()},
    );
  }
}
