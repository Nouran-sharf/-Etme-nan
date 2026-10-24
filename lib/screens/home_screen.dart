import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';
import '../data/mock_data.dart';
import '../models/appointment.dart';
import '../widgets/etmaenan_logo.dart';
import '../widgets/app_bar_language_switch.dart';
import 'health_awareness_screen.dart';

/// Screen 1: Home Screen
/// Provides clear branding with the official Etmaenan neon logo, a welcoming message,
/// Pink October awareness, photographic service cards, partner centers preview,
/// next appointment card, and a demo data reset action.
class HomeScreen extends StatelessWidget {
  final void Function(int tabIndex, {String? serviceFilter}) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
  });

  void _showPhotoCreditsDialog(BuildContext context, bool isArabic) {
    final appState = AppState.of(context);
    final centers = appState.medicalCenters;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.photo_library_rounded,
                color: AppTheme.primaryPurple, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppTranslations.tr('photoCreditsTitle', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppTranslations.tr('photoCreditsDesc', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    color: AppColors.darkText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                ...centers.map((c) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.getName(isArabic),
                            style: GoogleFonts.elMessiri(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${AppTranslations.tr('photoAuthor', isArabic)} ${c.photoAuthor}',
                            style: GoogleFonts.elMessiri(
                                fontSize: 12, color: Colors.grey.shade800),
                          ),
                          Text(
                            '${AppTranslations.tr('photoLicense', isArabic)} ${c.photoLicense}',
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.softPink.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.tr('photoNoticeResearch', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppTranslations.tr('photoNoticeResearchDesc', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 11,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppTranslations.tr('closeDialog', isArabic),
              style: GoogleFonts.elMessiri(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetDemoData(BuildContext context, AppState appState) {
    final isArabic = appState.isArabic;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          AppTranslations.tr('resetDemoDataTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          AppTranslations.tr('resetDemoDataMessage', isArabic),
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
                      AppTranslations.tr('resetSuccess', isArabic),
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

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final nextAppointment = appState.getNextUpcomingAppointment();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EtmaenanLogo(size: 32, borderRadius: 8),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppTranslations.tr('appName', isArabic),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.elMessiri(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        actions: const [
          AppBarLanguageSwitch(),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Welcome & Primary CTA Banner
              _buildWelcomeBanner(context, isArabic),

              const SizedBox(height: 20),

              // 2. Health & Awareness Dedicated Card (Screen 7 Shortcut)
              _buildHealthAwarenessCard(context, isArabic),

              const SizedBox(height: 20),

              // 3. Pink October Awareness Card with Official Logo
              _buildAwarenessCard(context, isArabic),

              const SizedBox(height: 24),

              // 3. Next Appointment Section
              _buildNextAppointmentSection(
                  context, appState, nextAppointment, isArabic),

              const SizedBox(height: 24),

              // 4. Four Specialized Photographic Service Shortcuts
              _buildServiceShortcuts(context, isArabic),

              const SizedBox(height: 24),

              // 5. Partner Medical Centers Preview
              _buildPartnerCentersSection(context, appState, isArabic),

              const SizedBox(height: 20),

              // Demo Disclaimer Footnote
              Center(
                child: Column(
                  children: [
                    Text(
                      AppTranslations.tr('demoNotice', isArabic),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.elMessiri(
                        fontSize: 12,
                        color: AppColors.mutedText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.photo_library_outlined, size: 16),
                          label: Text(
                            AppTranslations.tr('viewPhotoCredits', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.mutedText,
                          ),
                          onPressed: () =>
                              _showPhotoCreditsDialog(context, isArabic),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: Text(
                            AppTranslations.tr('resetDemoDataTitle', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.mutedText,
                          ),
                          onPressed: () =>
                              _confirmResetDemoData(context, appState),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Welcome Card with Primary CTA Button
  Widget _buildWelcomeBanner(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppTranslations.tr('demoBadge', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppTranslations.tr('homeWelcomeTitle', isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppTranslations.tr('homeWelcomeSubtitle', isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onNavigateToTab(1), // Tab 1 = Services & Doctors
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppTranslations.tr('bookAppointmentCta', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dedicated Health & Awareness Card (leads to Screen 7: HealthAwarenessScreen)
  Widget _buildHealthAwarenessCard(BuildContext context, bool isArabic) {
    return Container(
      key: const Key('health_awareness_card'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HealthAwarenessScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with badge and arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppTranslations.tr('awarenessCardBadge', isArabic),
                          style: GoogleFonts.elMessiri(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isArabic
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.softPink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.tr('awarenessCardTitle', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppTranslations.tr(
                                'awarenessCardSubtitle', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              color: AppColors.darkText,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Bottom reassurance & action row: LayoutBuilder adaptive layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textScale =
                        MediaQuery.textScalerOf(context).scale(1.0);
                    final isVeryNarrow =
                        constraints.maxWidth < 340 || textScale > 1.1;

                    if (isVeryNarrow) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_outlined,
                                  size: 15,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    AppTranslations.tr(
                                        'awarenessDisclaimer', isArabic),
                                    style: GoogleFonts.elMessiri(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppTranslations.tr(
                                  'exploreAwarenessCta', isArabic),
                              style: GoogleFonts.elMessiri(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            size: 15,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              AppTranslations.tr(
                                  'awarenessDisclaimer', isArabic),
                              style: GoogleFonts.elMessiri(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppTranslations.tr(
                                'exploreAwarenessCta', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pink October Awareness Banner with Official In-App Logo
  Widget _buildAwarenessCard(BuildContext context, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pinkAccent.withValues(alpha: 0.4)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HealthAwarenessScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EtmaenanLogo(size: 54, borderRadius: 14),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.pinkAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppTranslations.tr('pinkOctoberTag', isArabic),
                          style: GoogleFonts.elMessiri(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppTranslations.tr('pinkOctoberTitle', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppTranslations.tr('pinkOctoberDesc', isArabic),
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
          ),
        ),
      ),
    );
  }

  /// Next Appointment section with resilient adaptive stacking
  Widget _buildNextAppointmentSection(
    BuildContext context,
    AppState appState,
    Appointment? nextAppointment,
    bool isArabic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1.0);
            final bool shouldStack =
                constraints.maxWidth < (390 * textScale) || textScale > 1.25;

            final titleWidget = Text(
              AppTranslations.tr('nextAppointmentTitle', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            );

            final actionButton = TextButton(
              onPressed: () => onNavigateToTab(3), // Tab 3 = My Appointments
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppTranslations.tr('viewInAppointments', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            );

            if (shouldStack) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget,
                  const SizedBox(height: 2),
                  Align(
                    alignment:
                        isArabic ? Alignment.centerRight : Alignment.centerLeft,
                    child: actionButton,
                  ),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: titleWidget),
                const SizedBox(width: 8),
                Flexible(child: actionButton),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        if (nextAppointment != null)
          _buildUpcomingAppointmentCard(
              context, appState, nextAppointment, isArabic)
        else
          _buildEmptyAppointmentCard(context, isArabic),
      ],
    );
  }

  /// Detailed card when an upcoming appointment exists
  Widget _buildUpcomingAppointmentCard(
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
            LayoutBuilder(
              builder: (context, cardConstraints) {
                final isNarrow = cardConstraints.maxWidth < 280;

                final doctorPhoto = ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: doctor != null
                      ? Image.asset(
                          doctor.imageAsset,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 44,
                          height: 44,
                          color: AppColors.softPink,
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.primary),
                        ),
                );

                final doctorInfo = Column(
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
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );

                final statusBadge = Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        AppTranslations.tr('statusConfirmed', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          doctorPhoto,
                          const SizedBox(width: 10),
                          Expanded(child: doctorInfo),
                        ],
                      ),
                      const SizedBox(height: 8),
                      statusBadge,
                    ],
                  );
                }

                return Row(
                  children: [
                    doctorPhoto,
                    const SizedBox(width: 12),
                    Expanded(child: doctorInfo),
                    statusBadge,
                  ],
                );
              },
            ),
            const Divider(height: 18, color: AppColors.lightBorder),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 16, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: GoogleFonts.elMessiri(
                      fontSize: 13,
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 16, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Text(
                  appointment.timeSlot,
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (centerName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.mutedText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      centerName,
                      style: GoogleFonts.elMessiri(
                        fontSize: 12,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => onNavigateToTab(3),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  AppTranslations.tr('viewInAppointments', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state card when no upcoming appointments exist
  Widget _buildEmptyAppointmentCard(BuildContext context, bool isArabic) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppTranslations.tr('noUpcomingAppointments', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppTranslations.tr('noUpcomingAppointmentsDesc', isArabic),
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => onNavigateToTab(1),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppTranslations.tr('bookAppointmentCta', isArabic),
                style: GoogleFonts.elMessiri(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Four Service Shortcuts with real photographs (Deliverable 2)
  Widget _buildServiceShortcuts(BuildContext context, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslations.tr('quickServicesTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppTranslations.tr('quickServicesSubtitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 13,
            color: AppColors.mutedText,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemCount: mockServices.length,
          itemBuilder: (context, index) {
            final service = mockServices[index];
            return _buildServiceCard(context, service, isArabic);
          },
        ),
      ],
    );
  }

  /// Photographic service card with rounded corners and high readability
  Widget _buildServiceCard(
      BuildContext context, ServiceCategory service, bool isArabic) {
    final title = AppTranslations.tr(service.titleKey, isArabic);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          onNavigateToTab(1, serviceFilter: service.id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Image.asset(
                service.imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.white,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.elMessiri(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Partner Centers Preview row with shortcut to Centers Tab
  Widget _buildPartnerCentersSection(
      BuildContext context, AppState appState, bool isArabic) {
    final centers = appState.medicalCenters;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              AppTranslations.tr('partnerCentersTitle', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            TextButton(
              onPressed: () => onNavigateToTab(2), // Tab 2 = Centers
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppTranslations.tr('viewAllCenters', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: centers.length,
            itemBuilder: (ctx, idx) {
              final center = centers[idx];
              final rating = appState.getCenterAverageRating(center.id);

              return Container(
                width: 230,
                margin: EdgeInsets.only(
                  right: isArabic ? 0 : 12,
                  left: isArabic ? 12 : 0,
                ),
                child: Card(
                  elevation: 1.2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onNavigateToTab(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          center.imageAsset,
                          height: 95,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                center.getName(isArabic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.elMessiri(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFFFB800), size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      center.getCity(isArabic),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
