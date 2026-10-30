import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';

/// Reusable language switcher widget placed in the AppBar of every screen.
/// Switches immediately between Arabic and English without restarting or losing state.
class AppBarLanguageSwitch extends StatelessWidget {
  const AppBarLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final targetLangLabel = isArabic
        ? AppTranslations.tr('switchToEnglish', isArabic)
        : AppTranslations.tr('switchToArabic', isArabic);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: Tooltip(
        message: isArabic ? 'Switch to English' : 'التحويل إلى العربية',
        child: InkWell(
          onTap: () => appState.toggleLocale(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.softPink.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  targetLangLabel,
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
