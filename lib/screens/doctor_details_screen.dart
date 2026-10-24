import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';
import '../models/doctor.dart';
import '../widgets/app_bar_language_switch.dart';
import 'book_appointment_screen.dart';

/// Screen 3: Doctor Details Screen
/// Displays clinical portrait, years of experience, live star ratings,
/// affiliated medical center, clinical biography, appointment explanation,
/// and a prominent "Choose appointment" button.
class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final serviceName =
        AppTranslations.tr('service_${doctor.serviceId}', isArabic);
    final center = appState.getCenterById(doctor.centerId);
    final rating = appState.getDoctorAverageRating(doctor.id);
    final reviewCount = appState.getDoctorReviewCount(doctor.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          doctor.getName(isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        actions: const [
          AppBarLanguageSwitch(),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Doctor Profile Header Card
                    _buildProfileHeader(
                      context,
                      isArabic,
                      serviceName,
                      rating,
                      reviewCount,
                      center?.getName(isArabic) ?? '',
                    ),

                    const SizedBox(height: 20),

                    // Medical Center & Clinic Location Card
                    _buildClinicCard(context, center, isArabic),

                    const SizedBox(height: 20),

                    // Professional Biography Card
                    _buildBioCard(context, isArabic),

                    const SizedBox(height: 20),

                    // Explanation of Appointment Type Card
                    _buildAppointmentExplanationCard(context, isArabic),

                    const SizedBox(height: 16),

                    // Confidentiality Reassurance Note
                    _buildConfidentialityBadge(context, isArabic),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar with Prominent "Choose appointment" button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(
                  top: BorderSide(color: AppColors.lightBorder, width: 1.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkText.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => BookAppointmentScreen(
                        doctor: doctor,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.event_available_rounded, size: 20),
                label: Text(
                  AppTranslations.tr('chooseAppointmentButton', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 16,
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

  /// Profile Header with Portrait Photo, Name, Specialty, Rating, and Experience
  Widget _buildProfileHeader(
    BuildContext context,
    bool isArabic,
    String serviceName,
    double rating,
    int reviewCount,
    String centerName,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Column(
        children: [
          // Doctor Portrait Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              doctor.imageAsset,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                width: 90,
                height: 90,
                color: AppColors.softPink,
                child: const Icon(Icons.person_rounded,
                    size: 48, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            doctor.getName(isArabic),
            textAlign: TextAlign.center,
            style: GoogleFonts.elMessiri(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doctor.getSpecialty(isArabic),
            textAlign: TextAlign.center,
            style: GoogleFonts.elMessiri(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Star Rating & Review Count with Demo Rating Badge
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFB800), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${rating.toStringAsFixed(1)} / 5',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2036),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '($reviewCount ${AppTranslations.tr('reviewsCount', isArabic)})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppTranslations.tr('demoRatingLabel', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        size: 16, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Text(
                      '${doctor.experienceYears} ${AppTranslations.tr('experienceYears', isArabic)}',
                      style: GoogleFonts.elMessiri(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  serviceName,
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Clinic & Center location details card
  Widget _buildClinicCard(
      BuildContext context, dynamic center, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                AppTranslations.tr('clinicLocation', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (center != null) ...[
            Row(
              children: [
                const Icon(Icons.apartment_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    center.getName(isArabic),
                    style: GoogleFonts.elMessiri(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Text(
            doctor.getClinic(isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 13,
              color: AppColors.darkText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Biography section
  Widget _buildBioCard(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                AppTranslations.tr('aboutDoctor', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            doctor.getBiography(isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 13,
              color: AppColors.darkText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Explanation of Appointment Type
  Widget _buildAppointmentExplanationCard(
      BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                AppTranslations.tr('aboutAppointmentType', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            doctor.getAppointmentExplanation(isArabic),
            style: GoogleFonts.elMessiri(
              fontSize: 13,
              color: AppColors.darkText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Confidentiality Notice
  Widget _buildConfidentialityBadge(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pinkAccent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppTranslations.tr('confidentialityNotice', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
