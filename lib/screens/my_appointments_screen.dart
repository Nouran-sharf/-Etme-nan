import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';
import '../models/appointment.dart';
import '../widgets/app_bar_language_switch.dart';
import '../widgets/review_bottom_sheet.dart';
import 'book_appointment_screen.dart';

/// Screen 5: My Appointments Screen
/// Displays 4 tabs: All, Upcoming, Completed, and Cancelled/History.
/// Supports 6 statuses, shows doctor portraits, medical centers,
/// rescheduling, cancellation, and reviews for completed visits.
class MyAppointmentsScreen extends StatefulWidget {
  final void Function(int tabIndex, {String? serviceFilter}) onNavigateToTab;

  const MyAppointmentsScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Show respectful confirmation dialog before cancelling an appointment
  void _confirmCancel(
      BuildContext context, Appointment appointment, bool isArabic) {
    final appState = AppState.of(context);
    final doctor = appState.getDoctorById(appointment.doctorId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : appointment.doctorId;
    final formattedDate =
        AppTranslations.formatDate(appointment.date, isArabic);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.error, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppTranslations.tr('cancelDialogTitle', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslations.tr('cancelDialogMessage', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 14,
                  color: AppColors.darkText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: GoogleFonts.elMessiri(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    Text(
                      '$formattedDate - ${appointment.timeSlot}',
                      style: GoogleFonts.elMessiri(
                        fontSize: 12,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                AppTranslations.tr('keepAppointment', isArabic),
                style: GoogleFonts.elMessiri(
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                appState.cancelAppointment(appointment.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppTranslations.tr('cancelSuccess', isArabic),
                      style: GoogleFonts.elMessiri(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    backgroundColor: AppColors.darkText,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              child: Text(
                AppTranslations.tr('confirmCancel', isArabic),
                style: GoogleFonts.elMessiri(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;

    final allList = appState.appointments;
    final upcomingList = appState.getUpcomingAppointments();
    final completedList = appState.getCompletedAppointments();
    final cancelledList = appState.getCancelledAndOtherAppointments();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppTranslations.tr('myAppointmentsTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        actions: const [
          AppBarLanguageSwitch(),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.mutedText,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          isScrollable: true,
          labelStyle:
              GoogleFonts.elMessiri(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              GoogleFonts.elMessiri(fontSize: 14, fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: '${AppTranslations.tr('tabAll', isArabic)} (${allList.length})'),
            Tab(text: '${AppTranslations.tr('tabUpcoming', isArabic)} (${upcomingList.length})'),
            Tab(text: '${AppTranslations.tr('tabCompleted', isArabic)} (${completedList.length})'),
            Tab(text: '${AppTranslations.tr('tabCancelled', isArabic)} (${cancelledList.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(context, appState, allList, isArabic, 'emptyHistoryTitle'),
          _buildAppointmentList(context, appState, upcomingList, isArabic, 'emptyUpcomingTitle'),
          _buildAppointmentList(context, appState, completedList, isArabic, 'emptyCompletedTitle'),
          _buildAppointmentList(context, appState, cancelledList, isArabic, 'emptyHistoryTitle'),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(
    BuildContext context,
    AppState appState,
    List<Appointment> list,
    bool isArabic,
    String emptyKey,
  ) {
    if (list.isEmpty) {
      return _buildEmptyState(
        isArabic: isArabic,
        titleKey: emptyKey,
        descKey: 'noUpcomingAppointmentsDesc',
        icon: Icons.calendar_today_outlined,
        showCta: true,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return _buildAppointmentCard(
            context, appState, list[index], isArabic);
      },
    );
  }

  /// Unified card supporting all 6 statuses, portraits, and status-specific actions
  Widget _buildAppointmentCard(
    BuildContext context,
    AppState appState,
    Appointment appointment,
    bool isArabic,
  ) {
    final doctor = appState.getDoctorById(appointment.doctorId);
    final center = appState.getCenterById(appointment.centerId);
    final doctorName =
        doctor != null ? doctor.getName(isArabic) : appointment.doctorId;
    final centerName = center != null ? center.getName(isArabic) : '';
    final serviceName =
        AppTranslations.tr('service_${appointment.serviceId}', isArabic);
    final formattedDate =
        AppTranslations.formatDate(appointment.date, isArabic);
    final isReviewed = appState.isAppointmentReviewed(appointment.id);

    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Doctor photo + Service & Doctor name + Status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: doctor != null
                      ? Image.asset(
                          doctor.imageAsset,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 48,
                            height: 48,
                            color: AppColors.softPink,
                            child: const Icon(Icons.person_rounded,
                                color: AppColors.primary),
                          ),
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          color: AppColors.softPink,
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.primary),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: GoogleFonts.elMessiri(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        doctorName,
                        style: GoogleFonts.elMessiri(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(appointment.status, isArabic),
              ],
            ),

            // Postponed info note (if applicable)
            if (appointment.isPostponed &&
                appointment.originalDate != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD8B4FE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 14, color: Color(0xFF6B21A8)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${AppTranslations.tr('postponedNotice', isArabic)} ${AppTranslations.formatDate(appointment.originalDate!, isArabic)} (${appointment.originalTimeSlot ?? ''})',
                        style: GoogleFonts.elMessiri(
                          fontSize: 11,
                          color: const Color(0xFF6B21A8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 8),

            // Patient Name line
            Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    size: 15, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Text(
                  '${AppTranslations.tr('patientNameLabel', isArabic)}: ',
                  style: GoogleFonts.elMessiri(
                      fontSize: 12, color: AppColors.mutedText),
                ),
                Text(
                  appointment.patientName,
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),

            const Divider(height: 18, color: AppColors.lightBorder),

            // Date and Time
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 15, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: GoogleFonts.elMessiri(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                const Icon(Icons.access_time_rounded,
                    size: 15, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Text(
                  appointment.timeSlot,
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),

            // Medical Center line
            if (centerName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.apartment_rounded,
                      size: 15, color: AppColors.mutedText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      centerName,
                      style: GoogleFonts.elMessiri(
                        fontSize: 12,
                        color: AppColors.mutedText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Notes (if present)
            if (appointment.notes != null &&
                appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_rounded,
                      size: 15, color: AppColors.mutedText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      appointment.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // ==================== ACTIONS ====================
            if (appointment.isActiveUpcoming) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (doctor != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppointmentScreen(
                                doctor: doctor,
                                existingAppointment: appointment,
                              ),
                            ),
                          );
                        }
                      },
                      icon:
                          const Icon(Icons.edit_calendar_rounded, size: 16),
                      label: Text(
                        AppTranslations.tr('rescheduleAction', isArabic),
                        style: GoogleFonts.elMessiri(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _confirmCancel(context, appointment, isArabic),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.5),
                            width: 1.2),
                      ),
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: Text(
                        AppTranslations.tr('cancelAction', isArabic),
                        style: GoogleFonts.elMessiri(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (appointment.isCompleted) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  if (isReviewed) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFD54F)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: Color(0xFFFFB800)),
                          const SizedBox(width: 4),
                          Text(
                            AppTranslations.tr('reviewedBadge', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB78103),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ReviewBottomSheet.show(context, appointment);
                      },
                      icon: Icon(
                        isReviewed
                            ? Icons.edit_note_rounded
                            : Icons.rate_review_rounded,
                        size: 16,
                      ),
                      label: Text(
                        isReviewed
                            ? AppTranslations.tr('editReviewAction', isArabic)
                            : AppTranslations.tr('reviewAction', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isReviewed
                            ? AppTheme.primaryPurple
                            : const Color(0xFFFFB800),
                        foregroundColor:
                            isReviewed ? Colors.white : Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Badge rendering for all 6 statuses with semantic styling
  Widget _buildStatusBadge(AppointmentStatus status, bool isArabic) {
    Color bg;
    Color fg;
    IconData icon;
    String labelKey;

    switch (status) {
      case AppointmentStatus.confirmed:
        bg = AppColors.successBg;
        fg = AppColors.success;
        icon = Icons.check_circle_rounded;
        labelKey = 'statusConfirmed';
        break;
      case AppointmentStatus.pending:
        bg = const Color(0xFFFFF4E5);
        fg = const Color(0xFFB76E00);
        icon = Icons.hourglass_top_rounded;
        labelKey = 'statusPending';
        break;
      case AppointmentStatus.postponed:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF6B21A8);
        icon = Icons.update_rounded;
        labelKey = 'statusPostponed';
        break;
      case AppointmentStatus.completed:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        icon = Icons.task_alt_rounded;
        labelKey = 'statusCompleted';
        break;
      case AppointmentStatus.cancelled:
        bg = AppColors.errorBg;
        fg = AppColors.error;
        icon = Icons.cancel_rounded;
        labelKey = 'statusCancelled';
        break;
      case AppointmentStatus.noShow:
        bg = const Color(0xFFEEEEEE);
        fg = const Color(0xFF616161);
        icon = Icons.person_off_rounded;
        labelKey = 'statusNoShow';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            AppTranslations.tr(labelKey, isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state widget
  Widget _buildEmptyState({
    required bool isArabic,
    required String titleKey,
    required String descKey,
    required IconData icon,
    required bool showCta,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              AppTranslations.tr(titleKey, isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppTranslations.tr(descKey, isArabic),
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: AppColors.mutedText,
              ),
            ),
            if (showCta) ...[
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => widget.onNavigateToTab(1),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 44),
                ),
                child: Text(
                  AppTranslations.tr('bookAppointmentCta', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
