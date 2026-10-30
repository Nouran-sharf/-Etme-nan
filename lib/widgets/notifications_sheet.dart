import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../localization/app_translations.dart';
import '../models/app_notification.dart';

/// Bottom sheet displaying live session notifications generated from user actions
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  static Future<void> show(BuildContext context) {
    // Mark notifications as read upon opening
    AppState.of(context).markAllNotificationsAsRead();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final notifications = appState.notifications;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_rounded,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppTranslations.tr('notificationsTitle', isArabic),
                    style: GoogleFonts.elMessiri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (notifications.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      appState.clearNotifications();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppTranslations.tr('notificationCleared', isArabic),
                            style: GoogleFonts.elMessiri(
                                fontWeight: FontWeight.bold),
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      AppTranslations.tr('clearNotifications', isArabic),
                      style: GoogleFonts.elMessiri(
                        fontSize: 12,
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.lightBorder),

          // Content
          Flexible(
            child: notifications.isEmpty
                ? _buildEmptyState(context, isArabic)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (ctx, index) {
                      return _buildNotificationCard(
                          notifications[index], isArabic);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.softPink.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppTranslations.tr('noNotificationsTitle', isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppTranslations.tr('noNotificationsDesc', isArabic),
            textAlign: TextAlign.center,
            style: GoogleFonts.elMessiri(
              fontSize: 13,
              color: AppColors.mutedText,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notif, bool isArabic) {
    Color bg;
    Color iconColor;
    IconData icon;

    switch (notif.type) {
      case NotificationType.bookingConfirmed:
        bg = AppColors.successBg;
        iconColor = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case NotificationType.bookingRescheduled:
        bg = const Color(0xFFF3E8FF);
        iconColor = const Color(0xFF6B21A8);
        icon = Icons.edit_calendar_rounded;
        break;
      case NotificationType.bookingCancelled:
        bg = AppColors.errorBg;
        iconColor = AppColors.error;
        icon = Icons.cancel_rounded;
        break;
      case NotificationType.statusSimulated:
        bg = const Color(0xFFE0F2FE);
        iconColor = const Color(0xFF0369A1);
        icon = Icons.tune_rounded;
        break;
      case NotificationType.reviewSubmitted:
        bg = const Color(0xFFFFFBEB);
        iconColor = const Color(0xFFB45309);
        icon = Icons.star_rounded;
        break;
    }

    final timeStr =
        '${notif.timestamp.hour.toString().padLeft(2, '0')}:${notif.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif.getTitle(isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                    Text(
                      timeStr,
                      style: GoogleFonts.elMessiri(
                        fontSize: 11,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notif.getBody(isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    color: AppColors.darkText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar notification bell with badge counter
class AppBarNotificationButton extends StatelessWidget {
  const AppBarNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final unreadCount = appState.unreadNotificationsCount;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(),
          icon: Icon(
            unreadCount > 0
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            color: unreadCount > 0 ? AppColors.primary : AppColors.mutedText,
            size: 20,
          ),
          tooltip: AppTranslations.tr('notificationsBadgeTooltip', isArabic),
          onPressed: () => NotificationsSheet.show(context),
        ),
        if (unreadCount > 0)
          Positioned(
            top: 4,
            right: isArabic ? null : 4,
            left: isArabic ? 4 : null,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text(
                '$unreadCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
