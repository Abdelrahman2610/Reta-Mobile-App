import 'package:flutter/material.dart';
import 'package:reta/features/auth/presentation/pages/home_page.dart';
import 'package:reta/features/auth/presentation/pages/settings_page.dart';
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
      // For RTL/LTR support:
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: SettingsPage(),
    );
  }
}
