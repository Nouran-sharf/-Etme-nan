import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/medical_center.dart';
import '../state/app_state.dart';
import '../localization/app_translations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_language_switch.dart';
import 'services_doctors_screen.dart';

/// Screen listing verified partner medical centers in Egypt with search,
/// authentic Creative Commons photographs, contact details, ratings,
/// photo license attribution, and navigation to associated doctors.
class MedicalCentersScreen extends StatefulWidget {
  const MedicalCentersScreen({super.key});

  @override
  State<MedicalCentersScreen> createState() => _MedicalCentersScreenState();
}

class _MedicalCentersScreenState extends State<MedicalCentersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _showCenterDetails(
      BuildContext context, MedicalCenter center, bool isArabic) {
    final appState = AppState.of(context);
    final rating = appState.getCenterAverageRating(center.id);
    final reviewCount = appState.getCenterReviewCount(center.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  center.imageAsset,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                center.getName(isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
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
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount ${AppTranslations.tr('reviewsCount', isArabic)})',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
              Text(
                center.getDescription(isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.grey.shade800,
                ),
              ),
              const Divider(height: 24),

              // Contact & Facility Info
              Text(
                AppTranslations.tr('centerContactDemo', isArabic),
                style: GoogleFonts.elMessiri(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 10),
              _buildDetailRow(
                icon: Icons.location_on_rounded,
                label: AppTranslations.tr('centerAddress', isArabic),
                value: center.getAddress(isArabic),
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                icon: Icons.access_time_filled_rounded,
                label: AppTranslations.tr('centerHours', isArabic),
                value: center.getOpeningHours(isArabic),
              ),
              if (center.hotline.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailRow(
                  icon: Icons.support_agent_rounded,
                  label: AppTranslations.tr('centerHotline', isArabic),
                  value: center.hotline,
                ),
              ],
              const SizedBox(height: 8),
              _buildDetailRow(
                icon: Icons.phone_rounded,
                label: AppTranslations.tr('centerPhone', isArabic),
                value: center.phoneDemo,
              ),
              if (center.website.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailRow(
                  icon: Icons.language_rounded,
                  label: AppTranslations.tr('centerWebsite', isArabic),
                  value: center.website,
                ),
              ],
              const SizedBox(height: 8),
              _buildDetailRow(
                icon: Icons.email_rounded,
                label: AppTranslations.tr('centerEmail', isArabic),
                value: center.emailDemo,
              ),

              const SizedBox(height: 14),

              // Photograph Attribution & License
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt_outlined,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${AppTranslations.tr('photoAuthor', isArabic)} ${center.photoAuthor} • ${center.photoLicense}',
                        style: GoogleFonts.elMessiri(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                icon: const Icon(Icons.medical_services_rounded, size: 18),
                label: Text(
                  AppTranslations.tr('viewDoctorsAtCenter', isArabic),
                  style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ServicesDoctorsScreen(
                        initialCenterId: center.id,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryPurple),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: const Color(0xFF2D2036),
              ),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final centers = appState.medicalCenters;

    final filteredCenters = centers.where((center) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return center.getName(isArabic).toLowerCase().contains(q) ||
          center.getCity(isArabic).toLowerCase().contains(q) ||
          center.getAddress(isArabic).toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.tr('centersScreenTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: AppTheme.primaryPurple),
            tooltip: AppTranslations.tr('viewPhotoCredits', isArabic),
            onPressed: () => _showPhotoCreditsDialog(context, isArabic),
          ),
          const AppBarLanguageSwitch(),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppTranslations.tr('searchCentersHint', isArabic),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppTheme.primaryPurple),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppTheme.primaryPurple, width: 1.5),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),

          // Centers List
          Expanded(
            child: filteredCenters.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off_rounded,
                              size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            AppTranslations.tr('noCentersFoundTitle', isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppTranslations.tr('noCentersFoundDesc', isArabic),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.elMessiri(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filteredCenters.length,
                    itemBuilder: (context, index) {
                      final center = filteredCenters[index];
                      final rating = appState.getCenterAverageRating(center.id);
                      final reviewCount =
                          appState.getCenterReviewCount(center.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () =>
                              _showCenterDetails(context, center, isArabic),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Center Photo
                              Stack(
                                children: [
                                  Image.asset(
                                    center.imageAsset,
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: isArabic ? 10 : null,
                                    left: isArabic ? null : 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_city_rounded,
                                              size: 14, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            center.getCity(isArabic),
                                            style: GoogleFonts.elMessiri(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: isArabic ? null : 10,
                                    left: isArabic ? 10 : null,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        center.photoLicense,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title & Rating
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            center.getName(isArabic),
                                            style: GoogleFonts.elMessiri(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryPurple,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.star_rounded,
                                                    color: Color(0xFFFFB800),
                                                    size: 18),
                                                const SizedBox(width: 2),
                                                Text(
                                                  rating.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  ' ($reviewCount)',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              AppTranslations.tr(
                                                  'demoRatingLabel', isArabic),
                                              style: GoogleFonts.elMessiri(
                                                fontSize: 10,
                                                color: AppColors.mutedText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // Address
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 15,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            center.getAddress(isArabic),
                                            style: GoogleFonts.elMessiri(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Opening Hours & Hotline
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded,
                                            size: 15,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            center.getOpeningHours(isArabic),
                                            style: GoogleFonts.elMessiri(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Action buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            icon: const Icon(
                                                Icons.medical_services_outlined,
                                                size: 16),
                                            label: Text(
                                              AppTranslations.tr(
                                                  'viewDoctorsAtCenter',
                                                  isArabic),
                                              style: GoogleFonts.elMessiri(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  AppTheme.primaryPurple,
                                              side: const BorderSide(
                                                  color:
                                                      AppTheme.primaryPurple),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      ServicesDoctorsScreen(
                                                    initialCenterId: center.id,
                                                  ),
                                                ),
                                              );
                                            },
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
