import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color palette matching the Etmaenan / Pink October design specifications.
class AppColors {
  // Brand palette
  static const Color primary = Color(0xFF7F55B1); // Primary buttons, selected navigation, headings
  static const Color primaryPurple = Color(0xFF7F55B1);
  static const Color secondary = Color(0xFF9B7EBD); // Secondary accents & subtle decorative elements
  static const Color pinkOctober = Color(0xFFF49BAB); // Pink October accent & selected cards
  static const Color pinkAccent = Color(0xFFF49BAB);
  static const Color softPink = Color(0xFFFFE1E0); // Soft background sections

  // Neutral colors
  static const Color background = Color(0xFFFAF7FC); // Calming background
  static const Color surface = Color(0xFFFFFFFF); // Card background
  static const Color darkText = Color(0xFF261C2C); // High contrast text
  static const Color mutedText = Color(0xFF6C5F70); // Secondary body and caption text
  static const Color lightBorder = Color(0xFFE9E0EE); // Subtle borders
  static const Color white = Color(0xFFFFFFFF);

  // Semantic feedback colors
  static const Color success = Color(0xFF2E7D32); // Confirmed appointments & success
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFED6C02); // Attention & warnings
  static const Color warningBg = Color(0xFFFFF4E5);
  static const Color error = Color(0xFFD32F2F); // Errors & cancelled status
  static const Color errorBg = Color(0xFFFFEBEE);
}

/// Central application theme with El Messiri (المسيري) typography, rounded cards, and accessible touch targets.
class AppTheme {
  static const Color primaryPurple = AppColors.primary;
  static const Color secondaryPurple = AppColors.secondary;
  static const Color softPink = AppColors.softPink;
  static const Color pinkAccent = AppColors.pinkOctober;

  static ThemeData get lightTheme {
    final elMessiriFamily = GoogleFonts.elMessiri().fontFamily;

    return ThemeData(
      useMaterial3: true,
      fontFamily: elMessiriFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppColors.mutedText,
          fontSize: 12,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.elMessiri(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.elMessiri(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.elMessiri(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.softPink,
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: GoogleFonts.elMessiri(
          fontSize: 14,
          color: AppColors.darkText,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        labelStyle: GoogleFonts.elMessiri(fontSize: 14, color: AppColors.mutedText),
        hintStyle: GoogleFonts.elMessiri(fontSize: 14, color: AppColors.mutedText.withValues(alpha: 0.7)),
      ),
    );
  }
}
