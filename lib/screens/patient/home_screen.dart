import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/doctor.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _specialties = [
    'All',
    'Cardiology',
    'Dermatology',
    'Pediatrics',
    'Neurology',
  ];

  String _selectedSpecialty = 'All';
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  bool _showOverviewDrawer = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Doctor> get _filteredDoctors {
    return mockDoctors.where((doctor) {
      final matchesSpecialty =
          _selectedSpecialty == 'All' ||
          doctor.specialty.toLowerCase() == _selectedSpecialty.toLowerCase();
      final matchesSearch =
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  void _onDoctorSelected(Doctor doctor) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Selected ${doctor.name} (${doctor.specialty})',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: AppColors.deepOlive,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 95),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  IconData _getSpecialtyIcon(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'cardiology':
        return Icons.favorite_outline_rounded;
      case 'dermatology':
        return Icons.auto_awesome_outlined;
      case 'pediatrics':
        return Icons.child_care_rounded;
      case 'neurology':
        return Icons.psychology_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _filteredDoctors;
    final upcomingDoctor = mockDoctors.first; // Dr. Sarah Lee

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.34, 0.56, 1.0],
          colors: [
            AppColors.deepOlive,
            AppColors.sageGreen,
            AppColors.sageLight.withValues(alpha: 0.9),
            AppColors.cream,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ================= TOP HERO & APPOINTMENT SECTION =================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    // 1. Top Bar: Left Avatar + Right Frosted Search & Bell Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.sageLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.85),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.nearBlack.withValues(
                                  alpha: 0.12,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.face_3_rounded,
                            color: AppColors.deepOlive,
                            size: 26,
                          ),
                        ),
                        Row(
                          children: [
                            _buildGlassCircleIconButton(
                              icon: _isSearchExpanded
                                  ? Icons.close_rounded
                                  : Icons.search_rounded,
                              onTap: () {
                                setState(() {
                                  _isSearchExpanded = !_isSearchExpanded;
                                  if (!_isSearchExpanded &&
                                      _searchQuery.isNotEmpty) {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildGlassCircleIconButton(
                              icon: Icons.notifications_none_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Expandable Search Bar (Triggered by the top-right search glass button)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _isSearchExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox(height: 22),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 18),
                        child: _buildSearchBarField(),
                      ),
                    ),

                    // 2. Centered Greeting & Subtitle (Exact Reference Typography)
                    Text(
                      'Good Morning, Olivia Reed',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Search doctors or ask about your health...',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. "Upcoming Appointment" Section Title
                    Text(
                      'Upcoming Appointment',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Stacked Deck Card + Floating Bottom Chevron Button
                    _buildStackedUpcomingAppointmentCard(upcomingDoctor),

                    // Collapsible Drawer for Vitals & Medication Reminder (Toggled via the Chevron)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 280),
                      crossFadeState: _showOverviewDrawer
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox(height: 18),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 20),
                        child: _buildVitalsAndMedicationsSection(),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= BOTTOM ROUNDED SHEET CONTAINER =================
              Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 115),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepOlive.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 5. Specialty Filter Chips with Leading Medical Icons
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _specialties.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final specialty = _specialties[index];
                          final isSelected = _selectedSpecialty == specialty;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSpecialty = specialty;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.deepOlive
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.deepOlive
                                      : AppColors.sageGreen.withValues(
                                          alpha: 0.35,
                                        ),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.deepOlive.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getSpecialtyIcon(specialty),
                                    size: 16,
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.mutedText,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    specialty,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 6. "Find Specialist" Header + Count Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Find Specialist',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          '${doctors.length} available',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepOlive,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 7. Horizontal Portrait Doctor Cards (Exact Reference Card Style)
                    if (doctors.isEmpty)
                      _buildEmptyState()
                    else
                      SizedBox(
                        height: 232,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: doctors.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            return _buildDoctorPortraitCard(doctors[index]);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Frosted circular icon button for the top-right header
  Widget _buildGlassCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: AppColors.white, size: 21),
          ),
        ),
      ),
    );
  }

  /// Search input pill preserving all controller and query filter logic
  Widget _buildSearchBarField() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 6, top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppColors.nearBlack.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.darkText),
        decoration: InputDecoration(
          icon: const Icon(
            Icons.auto_awesome_outlined,
            size: 19,
            color: AppColors.deepOlive,
          ),
          hintText: 'Search doctors or ask about your health...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.mutedText,
          ),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: () {
              if (_searchQuery.isNotEmpty) {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.nearBlack,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _searchQuery.isNotEmpty
                    ? Icons.close_rounded
                    : Icons.mic_none_rounded,
                color: AppColors.white,
                size: 19,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Stacked 3-layer Upcoming Appointment Card with bottom floating chevron button
  Widget _buildStackedUpcomingAppointmentCard(Doctor doctor) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Back-most stacked card layer
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 34),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        // Middle stacked card layer
        Container(
          height: 90,
          margin: const EdgeInsets.only(top: 10, left: 18, right: 18),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        // Main Front White Card
        Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 18),
          child: GestureDetector(
            onTap: () => _onDoctorSelected(doctor),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOlive.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top row: Square Avatar + Details + Outlined North-East Arrow
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.sageLight,
                              AppColors.sageGreen.withValues(alpha: 0.45),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 42,
                          color: AppColors.deepOlive,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: GoogleFonts.poppins(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doctor.specialty,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.mutedText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13,
                                  color: AppColors.mutedText,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Tomorrow',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: AppColors.mutedText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppColors.mutedText,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4:30 PM',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: AppColors.mutedText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.sageGreen.withValues(alpha: 0.45),
                          ),
                        ),
                        child: const Icon(
                          Icons.north_east_rounded,
                          size: 17,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Bottom Dual Action Pills (Matches Reference Outlined + Filled Buttons)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _showOverviewDrawer = !_showOverviewDrawer;
                          }),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.sageGreen.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Today's Overview",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.deepOlive,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam_outlined,
                                size: 17,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Video Consultation',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Overlapping Bottom Circular Chevron Button (Toggles Vitals & Medication Drawer)
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showOverviewDrawer = !_showOverviewDrawer;
              });
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.sageLight, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOlive.withValues(alpha: 0.14),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _showOverviewDrawer
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.darkText,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Vertical Portrait Doctor Card matching the "Find a Doctor" row in the reference
  Widget _buildDoctorPortraitCard(Doctor doctor) {
    return GestureDetector(
      onTap: () => _onDoctorSelected(doctor),
      child: Container(
        width: 162,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOlive.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portrait Image Box with Top-Left Floating Rating Pill
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.sageLight.withValues(alpha: 0.8),
                      AppColors.sageGreen.withValues(alpha: 0.45),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.person_rounded,
                        size: 92,
                        color: AppColors.deepOlive.withValues(alpha: 0.85),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: AppColors.terracotta,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              doctor.rating.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Doctor Name
            Text(
              doctor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            // Specialty & Experience
            Text(
              '${doctor.specialty} • ${doctor.experienceYears}+ yrs exp',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 4),
            // Price per session
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$${doctor.consultationFee.toStringAsFixed(0)} ',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepOlive,
                    ),
                  ),
                  TextSpan(
                    text: '/session',
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Preserved Today's Overview & Medications Reminder Cards
  Widget _buildVitalsAndMedicationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(flex: 11, child: _buildHeartRateCard()),
            const SizedBox(width: 12),
            Expanded(flex: 9, child: _buildSleepQualityCard()),
          ],
        ),
        const SizedBox(height: 12),
        _buildMedicationBanner(),
      ],
    );
  }

  Widget _buildHeartRateCard() {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.lightTerracotta,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.terracotta,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Heart rate',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    'Normal',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: CustomPaint(painter: EcgWavePainter()),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.deepOlive,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '76',
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'bpm',
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        color: AppColors.sageLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualityCard() {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.sageLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppColors.deepOlive,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep Quality',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      'Good',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.deepOlive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            '7h 24m',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: AppColors.lightTerracotta,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      size: 15,
                      color: AppColors.terracotta,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Medications Reminder',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Paracetamol – 10:00 AM',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.sageLight.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.vaccines_outlined,
              color: AppColors.deepOlive,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 40,
            color: AppColors.deepOlive,
          ),
          const SizedBox(height: 8),
          Text(
            'No matching doctors found',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

class EcgWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.deepOlive
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height * 0.55;

    path.moveTo(0, midY);
    path.lineTo(size.width * 0.15, midY);
    path.lineTo(size.width * 0.22, midY - 18);
    path.lineTo(size.width * 0.28, midY + 14);
    path.lineTo(size.width * 0.34, midY - 6);
    path.lineTo(size.width * 0.40, midY);
    path.lineTo(size.width * 0.58, midY);
    path.lineTo(size.width * 0.65, midY - 22);
    path.lineTo(size.width * 0.72, midY + 16);
    path.lineTo(size.width * 0.78, midY - 8);
    path.lineTo(size.width * 0.85, midY);
    path.lineTo(size.width, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
