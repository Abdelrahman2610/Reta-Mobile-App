import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansArabic',

      colorScheme: const ColorScheme.light(
        primary: AppColors.mainBlueIndigoDye,
        secondary: AppColors.mainBlueSecondary,
        tertiary: AppColors.mainOrange,
        surface: AppColors.white,
        error: AppColors.errorDark,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.neutralDarkDarkest,
        onError: AppColors.white,
      ),

      scaffoldBackgroundColor: AppColors.neutralLightLightest,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mainBlueIndigoDye,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.actionXL,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineLarge: AppTextStyles.h3,
        headlineMedium: AppTextStyles.h4,
        headlineSmall: AppTextStyles.h5,
        titleLarge: AppTextStyles.h5,
        titleMedium: AppTextStyles.h6,
        titleSmall: AppTextStyles.h6,

        bodyLarge: AppTextStyles.bodyXL,
        bodyMedium: AppTextStyles.bodyL,
        bodySmall: AppTextStyles.bodyM,

        labelLarge: AppTextStyles.actionL,
        labelMedium: AppTextStyles.actionM,
        labelSmall: AppTextStyles.captionM,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainBlueIndigoDye,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.actionL,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mainBlueIndigoDye,
          textStyle: AppTextStyles.actionL,
          side: const BorderSide(
            color: AppColors.mainBlueIndigoDye,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mainBlueIndigoDye,
          textStyle: AppTextStyles.actionM,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: AppColors.neutralDarkLightest,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutralLightDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutralLightDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.mainBlueIndigoDye,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.neutralLightDark,
        thickness: 1,
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.neutralLightDark),
        ),
      ),
    );
  }
}
