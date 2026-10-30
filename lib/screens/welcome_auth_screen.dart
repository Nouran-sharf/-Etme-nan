import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../localization/app_translations.dart';
import '../widgets/etmaenan_logo.dart';
import '../widgets/app_bar_language_switch.dart';
import 'main_navigation_shell.dart';

/// Screen 0: Welcome / Authentication Screen with Demo Persona Sara (ساره)
/// Provides clear branding, bilingual language toggle, and dual entry options:
/// "تسجيل الدخول" (Log In) and "إنشاء حساب جديد" (Sign Up).
/// Both options immediately enter as Sara without requiring credentials or backend checks.
class WelcomeAuthScreen extends StatelessWidget {
  const WelcomeAuthScreen({super.key});

  void _enterAsSara(BuildContext context, {required bool isSignUp}) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;

    appState.loginAsDemoUser();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.verified_user_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic
                      ? 'أهلاً بكِ يا ساره في اطمئنان (حساب تجريبي) 🌸'
                      : 'Welcome Sara to Etme\'nan (Demo Account) 🌸',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          AppBarLanguageSwitch(),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding & Neon Logo
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.18),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const EtmaenanLogo(size: 80, borderRadius: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppTranslations.tr('appName', isArabic),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.elMessiri(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppTranslations.tr('welcomeSubtitle', isArabic),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.elMessiri(
                      fontSize: 13,
                      color: AppColors.mutedText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Demo Persona Card: Sara (ساره)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.softPink,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Avatar + Name + Demo Chip
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.softPink,
                              child: const Text(
                                'س',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      Text(
                                        appState.currentUserName,
                                        style: GoogleFonts.elMessiri(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.softPink,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          AppTranslations.tr(
                                              'demoUserTag', isArabic),
                                          style: GoogleFonts.elMessiri(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    AppTranslations.tr(
                                        'demoUserRole', isArabic),
                                    style: GoogleFonts.elMessiri(
                                      fontSize: 12,
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                            height: 24, color: AppColors.lightBorder),

                        // Notice text
                        Text(
                          AppTranslations.tr(
                              'demoAccountNoticeDesc', isArabic),
                          style: GoogleFonts.elMessiri(
                            fontSize: 13,
                            color: AppColors.darkText,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Highlight bullets
                        _buildFeatureBullet(
                          icon: Icons.calendar_today_rounded,
                          text: isArabic
                              ? 'تبدأ الجلسة بدون أي مواعيد سابقة'
                              : 'Session starts with zero past appointments',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureBullet(
                          icon: Icons.tune_rounded,
                          text: isArabic
                              ? 'محاكاة لكافة الحالات (مؤكد، مكتمل، ملغى...)'
                              : 'Simulate all states (confirmed, completed, etc.)',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureBullet(
                          icon: Icons.star_rounded,
                          text: isArabic
                              ? 'كتابة تقييمات تفاعلية للأطباء والمراكز'
                              : 'Write interactive reviews for doctors & centers',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Option 1: Log In Button
                  ElevatedButton.icon(
                    onPressed: () => _enterAsSara(context, isSignUp: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.login_rounded, size: 20),
                    label: Text(
                      AppTranslations.tr('loginButton', isArabic),
                      style: GoogleFonts.elMessiri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Option 2: Sign Up Button
                  OutlinedButton.icon(
                    onPressed: () => _enterAsSara(context, isSignUp: true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.person_add_outlined, size: 20),
                    label: Text(
                      AppTranslations.tr('signUpButton', isArabic),
                      style: GoogleFonts.elMessiri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Explanatory Hint
                  Text(
                    AppTranslations.tr('demoLoginHint', isArabic),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      color: AppColors.mutedText,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBullet({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryPurple),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.elMessiri(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
        ),
      ],
    );
  }
}
