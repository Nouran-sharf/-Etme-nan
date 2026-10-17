import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // الدرجات الجديدة الأغمق والأكثر تشبعاً
  static const Color sageLight = Color(0xFFC5D1B5);
  static const Color sageGreen = Color(0xFF7E9470);
  static const Color cream = Color(0xFFEAE0D2);
  static const Color terracotta = Color(0xFFB2593A);
  static const Color deepOlive = Color(0xFF3E4A35);

  // ألوان النصوص والعناصر الإضافية بدرجات أعمق
  static const Color darkText = Color(0xFF1F241C);
  static const Color mutedText = Color(0xFF5A5D53);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightTerracotta = Color(0xFFE5C5B5);
  static const Color nearBlack = Color(0xFF141812);
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.mutedText,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.deepOlive,
        primary: AppColors.deepOlive,
        secondary: AppColors.terracotta,
        surface: AppColors.cream,
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }
}