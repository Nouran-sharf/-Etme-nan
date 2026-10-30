import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../localization/app_translations.dart';
import '../models/appointment.dart';
import 'review_bottom_sheet.dart';

/// Interactive Demo Control Sheet allowing evaluators to simulate
/// any appointment state transition immediately without waiting.
class AppointmentStatusSimulatorSheet extends StatelessWidget {
  final Appointment appointment;

  const AppointmentStatusSimulatorSheet({
    super.key,
    required this.appointment,
  });

  static Future<void> show(BuildContext context, Appointment appointment) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          AppointmentStatusSimulatorSheet(appointment: appointment),
    );
  }

  void _applyStatus(
      BuildContext context, AppState appState, AppointmentStatus status) {
    final isArabic = appState.isArabic;

    Navigator.of(context).pop();
    appState.simulateAppointmentStatus(appointment.id, status);

    final statusLabel = AppTranslations.tr(
      status == AppointmentStatus.confirmed
          ? 'statusConfirmed'
          : status == AppointmentStatus.pending
              ? 'statusPending'
              : status == AppointmentStatus.postponed
                  ? 'statusPostponed'
                  : status == AppointmentStatus.completed
                      ? 'statusCompleted'
                      : status == AppointmentStatus.cancelled
                          ? 'statusCancelled'
                          : 'statusNoShow',
      isArabic,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${AppTranslations.tr('statusSimulatedSuccess', isArabic)} $statusLabel',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: status == AppointmentStatus.completed
              ? SnackBarAction(
                  label: AppTranslations.tr('reviewNowCta', isArabic),
                  textColor: const Color(0xFFFFD54F),
                  onPressed: () {
                    final updatedApt = appState.appointments.firstWhere(
                      (a) => a.id == appointment.id,
                      orElse: () => appointment,
                    );
                    ReviewBottomSheet.show(context, updatedApt);
                  },
                )
              : null,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final doctor = appState.getDoctorById(appointment.doctorId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : appointment.doctorId;
    final formattedDate =
        AppTranslations.formatDate(appointment.date, isArabic);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                const Icon(Icons.tune_rounded,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.tr('simulateStateTitle', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '$doctorName • $formattedDate (${appointment.timeSlot})',
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
          ),
          const Divider(height: 1, color: AppColors.lightBorder),

          // Instructions
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              AppTranslations.tr('simulateStateDesc', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: AppColors.darkText,
                height: 1.4,
              ),
            ),
          ),

          // Status Options List
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatusOption(
                  context: context,
                  status: AppointmentStatus.confirmed,
                  currentStatus: appointment.status,
                  title:
                      AppTranslations.tr('statusConfirmedTitle', isArabic),
                  desc: AppTranslations.tr('statusConfirmedDesc', isArabic),
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  bg: AppColors.successBg,
                  onTap: () => _applyStatus(
                      context, appState, AppointmentStatus.confirmed),
                ),
                const SizedBox(height: 10),
                _buildStatusOption(
                  context: context,
                  status: AppointmentStatus.pending,
                  currentStatus: appointment.status,
                  title: AppTranslations.tr('statusPendingTitle', isArabic),
                  desc: AppTranslations.tr('statusPendingDesc', isArabic),
                  icon: Icons.hourglass_top_rounded,
                  color: const Color(0xFFB76E00),
                  bg: const Color(0xFFFFF4E5),
                  onTap: () => _applyStatus(
                      context, appState, AppointmentStatus.pending),
                ),
                const SizedBox(height: 10),
                _buildStatusOption(
                  context: context,
                  status: AppointmentStatus.postponed,
                  currentStatus: appointment.status,
                  title:
                      AppTranslations.tr('statusPostponedTitle', isArabic),
                  desc: AppTranslations.tr('statusPostponedDesc', isArabic),
                  icon: Icons.update_rounded,
                  color: const Color(0xFF6B21A8),
                  bg: const Color(0xFFF3E8FF),
                  onTap: () => _applyStatus(
                      context, appState, AppointmentStatus.postponed),
                ),
                const SizedBox(height: 10),
                _buildStatusOption(
                  context: context,
                  status: AppointmentStatus.completed,
                  currentStatus: appointment.status,
                  title:
                      AppTranslations.tr('statusCompletedTitle', isArabic),
                  desc: AppTranslations.tr('statusCompletedDesc', isArabic),
                  icon: Icons.task_alt_rounded,
                  color: const Color(0xFF2E7D32),
                  bg: const Color(0xFFE8F5E9),
                  onTap: () => _applyStatus(
                      context, appState, AppointmentStatus.completed),
                ),
                const SizedBox(height: 10),
                _buildStatusOption(
                  context: context,
                  status: AppointmentStatus.cancelled,
                  currentStatus: appointment.status,
                  title:
                      AppTranslations.tr('statusCancelledTitle', isArabic),
                  desc: AppTranslations.tr('statusCancelledDesc', isArabic),
                  icon: Icons.cancel_rounded,
                  color: AppColors.error,
                  bg: AppColors.errorBg,
                  onTap: () => _applyStatus(
                      context, appState, AppointmentStatus.cancelled),
                ),
                const SizedBox(height: 10),
                _buildStatusOption(
                  context: context,
                  status: AppointmentStatus.noShow,
                  currentStatus: appointment.status,
                  title: AppTranslations.tr('statusNoShowTitle', isArabic),
                  desc: AppTranslations.tr('statusNoShowDesc', isArabic),
                  icon: Icons.person_off_rounded,
                  color: const Color(0xFF616161),
                  bg: const Color(0xFFEEEEEE),
                  onTap: () => _applyStatus(
                      context, appState, AppointmentStatus.noShow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption({
    required BuildContext context,
    required AppointmentStatus status,
    required AppointmentStatus currentStatus,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    final isSelected = status == currentStatus;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.25),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.elMessiri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'الحالية / Active',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      color: AppColors.darkText,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
