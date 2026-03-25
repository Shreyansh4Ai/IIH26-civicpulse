import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final headlineFont = GoogleFonts.publicSansTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: TextTheme(
        // Headlines → Public Sans
        displayLarge: headlineFont.displayLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: AppColors.onSurface,
          letterSpacing: -1.5,
        ),
        displayMedium: headlineFont.displayMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: AppColors.onSurface,
          letterSpacing: -1.0,
        ),
        displaySmall: headlineFont.displaySmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: AppColors.onSurface,
        ),
        headlineLarge: headlineFont.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
        ),
        headlineMedium: headlineFont.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        headlineSmall: headlineFont.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleLarge: headlineFont.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleMedium: headlineFont.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleSmall: headlineFont.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        // Body → Inter
        bodyLarge: bodyFont.bodyLarge?.copyWith(
          color: AppColors.onSurface,
        ),
        bodyMedium: bodyFont.bodyMedium?.copyWith(
          color: AppColors.onSurface,
        ),
        bodySmall: bodyFont.bodySmall?.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: bodyFont.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        labelMedium: bodyFont.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelSmall: bodyFont.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
