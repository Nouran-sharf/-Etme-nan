import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../localization/app_translations.dart';
import 'app_bar_language_switch.dart';
import 'notifications_sheet.dart';
import '../screens/welcome_auth_screen.dart';

/// Combined AppBar action row containing:
/// 1. Notifications bell with live unread badge
/// 2. Language toggle button (Arabic / English)
/// 3. Demo User Avatar chip (Sara / ساره) with quick access to Reset Demo and Logout
class DemoAppBarActions extends StatelessWidget {
  const DemoAppBarActions({super.key});

  void _showDemoProfileDialog(BuildContext context, AppState appState) {
    final isArabic = appState.isArabic;
    final activeCount = appState.getUpcomingAppointments().length;
    final completedCount = appState.getCompletedAppointments().length;
    final notifsCount = appState.notifications.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.softPink,
              child: Text(
                isArabic ? 'س' : 'S',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.tr('demoProfileTitle', isArabic),
                    style: GoogleFonts.elMessiri(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    AppTranslations.tr('demoUserRole', isArabic),
                    style: GoogleFonts.elMessiri(
                      fontSize: 11,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.tr('demoProfileSubtitle', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: AppColors.darkText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.tr('demoSessionStats', isArabic),
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildStatRow(
                    AppTranslations.tr('demoActiveBookings', isArabic),
                    '$activeCount',
                  ),
                  _buildStatRow(
                    AppTranslations.tr('demoCompletedBookings', isArabic),
                    '$completedCount',
                  ),
                  _buildStatRow(
                    AppTranslations.tr('demoGeneratedNotifications', isArabic),
                    '$notifsCount',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // View Notifications Button (especially helpful on narrow screens)
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                NotificationsSheet.show(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.notifications_outlined, size: 18),
              label: Text(
                AppTranslations.tr('notificationsTitle', isArabic),
                style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            // Reset Demo Button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                _confirmResetDemo(context, appState);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryPurple,
                side: BorderSide(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.6)),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                AppTranslations.tr('resetDemoAction', isArabic),
                style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            // Logout Button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                _confirmLogout(context, appState);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(
                AppTranslations.tr('logoutButton', isArabic),
                style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppTranslations.tr('closeDialog', isArabic),
              style: GoogleFonts.elMessiri(
                fontWeight: FontWeight.bold,
                color: AppColors.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetDemo(BuildContext context, AppState appState) {
    final isArabic = appState.isArabic;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          AppTranslations.tr('resetDemoAction', isArabic),
          style: GoogleFonts.elMessiri(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          AppTranslations.tr('resetDemoPrompt', isArabic),
          style: GoogleFonts.elMessiri(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppTranslations.tr('resetCancelButton', isArabic),
              style: GoogleFonts.elMessiri(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await appState.resetDemoData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppTranslations.tr('resetDemoSuccess', isArabic),
                      style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: AppTheme.primaryPurple,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              AppTranslations.tr('resetConfirmButton', isArabic),
              style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppState appState) {
    final isArabic = appState.isArabic;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          AppTranslations.tr('logoutConfirmTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          AppTranslations.tr('logoutConfirmMessage', isArabic),
          style: GoogleFonts.elMessiri(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppTranslations.tr('resetCancelButton', isArabic),
              style: GoogleFonts.elMessiri(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              appState.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                (route) => false,
              );
            },
            child: Text(
              AppTranslations.tr('logoutButton', isArabic),
              style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isVeryNarrow = screenWidth < 360;

    if (isVeryNarrow) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBarLanguageSwitch(),
          Tooltip(
            message: AppTranslations.tr('demoUserBadge', isArabic),
            child: InkWell(
              onTap: () => _showDemoProfileDialog(context, appState),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.softPink,
                  child: Text(
                    isArabic ? 'س' : 'S',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live notifications bell with counter badge
        const AppBarNotificationButton(),

        // Bilingual language toggle
        const AppBarLanguageSwitch(),

        const SizedBox(width: 4),

        // Demo User Avatar button
        Tooltip(
          message: AppTranslations.tr('demoUserBadge', isArabic),
          child: InkWell(
            onTap: () => _showDemoProfileDialog(context, appState),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.softPink,
                child: Text(
                  isArabic ? 'س' : 'S',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 4),
      ],
    );
  }
}
