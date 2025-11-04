import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.cerulean,
        primary: AppColors.cerulean,
        secondary: AppColors.persimmon,
        background: AppColors.background,
        surface: AppColors.background,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: AppColors.onBackground,
        onSurface: AppColors.onBackground,
        error: AppColors.error,
        onError: Colors.white,
        brightness: Brightness.light,
        surfaceVariant: AppColors.rose,
        onSurfaceVariant: AppColors.cerulean,
        secondaryContainer: AppColors.rose,
        onSecondaryContainer: AppColors.persimmon,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.cerulean),
        titleTextStyle: TextStyle(
          color: AppColors.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.rose.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cerulean, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.cerulean),
        prefixIconColor: MaterialStateColor.resolveWith((states) {
          return states.contains(MaterialState.focused)
              ? AppColors.cerulean
              : AppColors.onBackground.withOpacity(0.6);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cerulean,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.persimmon,
          side: const BorderSide(color: AppColors.persimmon, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
