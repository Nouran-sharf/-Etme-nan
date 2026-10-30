import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';
import '../models/doctor.dart';
import '../data/mock_data.dart';
import '../widgets/demo_app_bar_actions.dart';
import 'doctor_details_screen.dart';

/// Screen 2: Services & Doctors Screen
/// Provides a search field, service filter chips ("All" + 4 services),
/// medical center filter chips, doctor portrait cards with live star ratings,
/// and an empty state when no results match.
class ServicesDoctorsScreen extends StatefulWidget {
  final String? initialFilter;
  final String? initialCenterId;

  const ServicesDoctorsScreen({
    super.key,
    this.initialFilter,
    this.initialCenterId,
  });

  @override
  State<ServicesDoctorsScreen> createState() => _ServicesDoctorsScreenState();
}

class _ServicesDoctorsScreenState extends State<ServicesDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedServiceId;
  late String _selectedCenterId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.initialFilter ?? 'all';
    _selectedCenterId = widget.initialCenterId ?? 'all';
  }

  @override
  void didUpdateWidget(covariant ServicesDoctorsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilter != null &&
        widget.initialFilter != oldWidget.initialFilter) {
      setState(() {
        _selectedServiceId = widget.initialFilter!;
      });
    }
    if (widget.initialCenterId != null &&
        widget.initialCenterId != oldWidget.initialCenterId) {
      setState(() {
        _selectedCenterId = widget.initialCenterId!;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Reset search query, service filter, and center filter
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedServiceId = 'all';
      _selectedCenterId = 'all';
    });
  }

  /// Combined filter applying search text, service category, and medical center
  List<Doctor> _getFilteredDoctors(AppState appState) {
    return appState.doctors.where((doctor) {
      // 1. Service filter
      final matchesService = _selectedServiceId == 'all' ||
          doctor.serviceId == _selectedServiceId;

      // 2. Center filter
      final matchesCenter = _selectedCenterId == 'all' ||
          doctor.centerId == _selectedCenterId;

      if (!matchesService || !matchesCenter) return false;

      // 3. Search query
      if (_searchQuery.trim().isEmpty) return true;

      final query = _searchQuery.trim().toLowerCase();
      final matchesNameAr = doctor.nameAr.toLowerCase().contains(query);
      final matchesNameEn = doctor.nameEn.toLowerCase().contains(query);
      final matchesSpecialtyAr =
          doctor.specialtyAr.toLowerCase().contains(query);
      final matchesSpecialtyEn =
          doctor.specialtyEn.toLowerCase().contains(query);
      final matchesClinicAr = doctor.clinicAr.toLowerCase().contains(query);
      final matchesClinicEn = doctor.clinicEn.toLowerCase().contains(query);

      return matchesNameAr ||
          matchesNameEn ||
          matchesSpecialtyAr ||
          matchesSpecialtyEn ||
          matchesClinicAr ||
          matchesClinicEn;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;
    final doctors = _getFilteredDoctors(appState);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppTranslations.tr('servicesScreenTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        actions: const [
          DemoAppBarActions(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Field & Filter Chips Header
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: AppTranslations.tr('searchHint', isArabic),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              tooltip: 'مسح / Clear',
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Horizontal Service Filter Chips
                  _buildServiceFilterChips(isArabic),

                  const SizedBox(height: 8),

                  // Horizontal Center Filter Chips
                  _buildCenterFilterChips(appState, isArabic),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.lightBorder),

            // Doctors List or Empty State
            Expanded(
              child: doctors.isEmpty
                  ? _buildEmptyResultsState(isArabic)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: doctors.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return _buildDoctorCard(
                            context, appState, doctors[index], isArabic);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Horizontal scrolling list of service filter chips
  Widget _buildServiceFilterChips(bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(
              AppTranslations.tr('filterAll', isArabic),
              style: GoogleFonts.elMessiri(
                fontWeight: _selectedServiceId == 'all'
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: _selectedServiceId == 'all'
                    ? AppColors.primary
                    : AppColors.darkText,
              ),
            ),
            selected: _selectedServiceId == 'all',
            selectedColor: AppColors.softPink,
            backgroundColor: AppColors.white,
            side: BorderSide(
              color: _selectedServiceId == 'all'
                  ? AppColors.primary
                  : AppColors.lightBorder,
              width: 1.2,
            ),
            onSelected: (selected) {
              if (selected) setState(() => _selectedServiceId = 'all');
            },
          ),
          const SizedBox(width: 8),
          ...mockServices.map((service) {
            final isSelected = _selectedServiceId == service.id;
            final label = AppTranslations.tr(service.titleKey, isArabic);

            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ChoiceChip(
                label: Text(
                  label,
                  style: GoogleFonts.elMessiri(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.darkText,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.softPink,
                backgroundColor: AppColors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.lightBorder,
                  width: 1.2,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedServiceId = service.id);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Horizontal scrolling list of center filter chips
  Widget _buildCenterFilterChips(AppState appState, bool isArabic) {
    final centers = appState.medicalCenters;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          ChoiceChip(
            label: Text(
              AppTranslations.tr('allCenters', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 12,
                fontWeight: _selectedCenterId == 'all'
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: _selectedCenterId == 'all'
                    ? AppTheme.primaryPurple
                    : AppColors.darkText,
              ),
            ),
            selected: _selectedCenterId == 'all',
            selectedColor: AppTheme.softPink.withValues(alpha: 0.5),
            backgroundColor: AppColors.white,
            side: BorderSide(
              color: _selectedCenterId == 'all'
                  ? AppTheme.primaryPurple
                  : AppColors.lightBorder,
              width: 1,
            ),
            onSelected: (selected) {
              if (selected) setState(() => _selectedCenterId = 'all');
            },
          ),
          ...centers.map((center) {
            final isSelected = _selectedCenterId == center.id;
            return Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: ChoiceChip(
                label: Text(
                  center.getName(isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.primaryPurple
                        : AppColors.darkText,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.softPink.withValues(alpha: 0.5),
                backgroundColor: AppColors.white,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryPurple
                      : AppColors.lightBorder,
                  width: 1,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedCenterId = center.id);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Individual Doctor Card with portrait, star rating, center affiliation, and CTA
  Widget _buildDoctorCard(
      BuildContext context, AppState appState, Doctor doctor, bool isArabic) {
    final serviceName =
        AppTranslations.tr('service_${doctor.serviceId}', isArabic);
    final expYears =
        '${doctor.experienceYears} ${AppTranslations.tr('experienceYears', isArabic)}';
    final center = appState.getCenterById(doctor.centerId);
    final rating = appState.getDoctorAverageRating(doctor.id);
    final reviewCount = appState.getDoctorReviewCount(doctor.id);

    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Photographic Portrait
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    doctor.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.softPink,
                      child: const Icon(Icons.person_rounded,
                          size: 36, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Gender/Type
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            doctor.getName(isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: doctor.isMale
                                  ? Colors.blue.shade50
                                  : AppColors.softPink.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              doctor.isMale
                                  ? AppTranslations.tr('genderMale', isArabic)
                                  : AppTranslations.tr(
                                      'genderFemale', isArabic),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: doctor.isMale
                                    ? Colors.blue.shade800
                                    : AppTheme.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.getSpecialty(isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Live Yellow Star Rating, Demo Tag & Experience
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 2,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFFFB800), size: 16),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${rating.toStringAsFixed(1)} / 5 ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D2036),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '($reviewCount)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '•  ${AppTranslations.tr('demoRatingLabel', isArabic)}',
                            style: GoogleFonts.elMessiri(
                              fontSize: 10,
                              color: AppColors.mutedText,
                            ),
                          ),
                          Text(
                            '•  $expYears',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Center Badge & Service Badge
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (center != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.apartment_rounded,
                            size: 13, color: AppTheme.primaryPurple),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            center.getName(isArabic),
                            style: GoogleFonts.elMessiri(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.softPink.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    serviceName,
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

            // View Details Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => DoctorDetailsScreen(doctor: doctor),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppTranslations.tr('viewDetailsButton', isArabic),
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

  /// Empty state when no doctors match filter and search
  Widget _buildEmptyResultsState(bool isArabic) {
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
              child: const Icon(
                Icons.search_off_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppTranslations.tr('noDoctorsFoundTitle', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppTranslations.tr('noDoctorsFoundDesc', isArabic),
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _clearFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppTranslations.tr('clearFiltersButton', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
