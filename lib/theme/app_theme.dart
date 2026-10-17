import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // الألوان الجديدة المطلوبة
  static const Color cream = Color(
    0xFFFFFAF4,
  ); // rgb(255, 250, 244) - خلفية الشاشات
  static const Color deepOlive = Color(
    0xFFD25380,
  ); // rgb(210, 83, 128) - اللون الأساسي البارز
  static const Color terracotta = Color(
    0xFFE08E6D,
  ); // rgb(224, 142, 109) - اللون الثانوي/التخصصات
  static const Color sageLight = Color(
    0xFFF6C391,
  ); // rgb(246, 195, 145) - خلفيات الكروت الفاتحة
  static const Color sageGreen = Color(
    0xFFE8AB78,
  ); // درجة متناسقة للحواف والتدرجات

  // ألوان النصوص والعناصر المساعدة
  static const Color darkText = Color(
    0xFF3B1E2B,
  ); // نص داكن متناسق مع الباليت الوردي/الدافئ
  static const Color mutedText = Color(0xFF8C6E78); // نص فرعي هادئ
  static const Color white = Color(0xFFFFFFFF); // أبيض ناصع للكروت
  static const Color lightTerracotta = Color(
    0xFFFCE8DF,
  ); // خلفية فرعية دافئة جداً
  static const Color nearBlack = Color(0xFF261019); // داكن جداً للأزرار السفلية
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
