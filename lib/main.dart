import 'dart:developer';

import 'package:developer_mode/developer_mode.dart';
import 'package:flutter/foundation.dart';
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
import 'package:root_jailbreak_sniffer/rjsniffer.dart';

// import 'core/widgets/inactivity_detector.dart';

import 'core/helpers/runtime_data.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/security_screen.dart';
import 'features/payment/presentations/cubit/settlement/my_debts_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting('ar');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // checkIfDeviceRoot();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // checkIfDeviceRoot();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  checkIfDeviceRoot() async {
    bool isDeviceRoot = await isRoot();
    if (isDeviceRoot) {
      Navigator.of(
        RuntimeData.getCurrentContext()!,
        rootNavigator: true,
      ).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SecurityScreen()),
        (route) => false,
      );
      return;
    }
  }

  Future<bool> isRoot() async {
    bool amICompromised = false;
    bool amIEmulator = false;
    bool amIDebugged = false;
    bool isJailbroken = false;
    bool isDeveloperMode = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      amICompromised = await Rjsniffer.amICompromised() ?? false;
      amIEmulator = await Rjsniffer.amIEmulator() ?? false;
      // amIDebugged = await Rjsniffer.amIDebugged() ?? false;
      // 🚨 Ignore debug detection in debug mode
      if (!kDebugMode) {
        amIDebugged = await Rjsniffer.amIDebugged() ?? false;
      }
      isJailbroken = await DeveloperMode.isJailbroken;
      isDeveloperMode = await DeveloperMode.isDeveloperMode;
    } on PlatformException {
      //platform call failed
    }
    log("amICompromised: $amICompromised");
    log("amIEmulator: $amIEmulator");
    log("amIDebugged: $amIDebugged");
    log("isJailbroken: $isJailbroken");
    log("isDeveloperMode: $isDeveloperMode");
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return false;
    return amIDebugged ||
        amIEmulator ||
        amICompromised ||
        isJailbroken | isDeveloperMode;
  }

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
          BlocProvider(create: (_) => MyDebtsCubit()..fetchDeclarations()),
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
