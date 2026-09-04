import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design language: "ethereal utilitarian" — a quiet, misty, low-saturation
/// backdrop (the "ethereal" half) that stays out of the way of a dense,
/// legible, function-first list interface (the "utilitarian" half). Nothing
/// here is decorative for its own sake: color marks whose list you're on,
/// and the one moment of real visual weight is the sub-total itself.
class AppColors {
  AppColors._();

  static const background = Color(0xFFF1F4EE); // pale, cool, misty white
  static const surface = Color(0xFFFBFCF9);
  static const surfaceMuted = Color(0xFFE7EBE1);
  static const divider = Color(0xFFDCE2D4);

  static const ink = Color(0xFF262B24); // cool charcoal, not pure black
  static const inkMuted = Color(0xFF848A7C);
  static const inkFaint = Color(0xFFAEB4A4);

  static const sage = Color(0xFF6C8C70);
  static const sageDeep = Color(0xFF48624C);
  static const terracotta = Color(0xFFBF7860); // reserved for delete only
}

class AppTheme {
  AppTheme._();

  /// The one deliberately "loud" text style in the app, reserved for the
  /// sub-total figure — a distinct geometric face so the number a person
  /// actually came here for reads as the payoff, not just more list text.
  static TextStyle subtotalStyle({required Color color}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: 30,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static ThemeData get theme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.sage,
        onPrimary: Colors.white,
        secondary: AppColors.sage,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.terracotta,
      ),
      dividerColor: AppColors.divider,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w300,
          letterSpacing: -0.4,
          color: AppColors.ink,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: AppColors.ink),
        bodySmall: textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 21,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.3,
          color: AppColors.ink,
        ),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        extendedTextStyle: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          borderSide: const BorderSide(color: AppColors.sage, width: 1.4),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.inkMuted),
      ),
    );
  }
}
