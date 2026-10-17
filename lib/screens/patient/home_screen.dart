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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Doctor> get _filteredDoctors {
    return mockDoctors.where((doctor) {
      final matchesSpecialty = _selectedSpecialty == 'All' ||
          doctor.specialty.toLowerCase() == _selectedSpecialty.toLowerCase();
      final matchesSearch = doctor.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
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

  @override
  Widget build(BuildContext context) {
    final doctors = _filteredDoctors;
    final upcomingDoctor = mockDoctors.first; // Dr. Sarah Lee

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.sageLight.withValues(alpha: 0.55),
            AppColors.cream,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 115),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Avatar + "Good Morning, Olivia Reed" + Bell Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.face_3_rounded,
                          color: AppColors.deepOlive,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                          ),
                          Text(
                            'Olivia Reed',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.sageGreen.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.darkText,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. Search Bar Pill with Black Circular Mic/Search Icon (Exact Reference Style)
              Container(
                padding: const EdgeInsets.only(left: 16, right: 6, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepOlive.withValues(alpha: 0.05),
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
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.darkText,
                  ),
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.auto_awesome_outlined,
                      size: 20,
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
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.nearBlack,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _searchQuery.isNotEmpty
                              ? Icons.close_rounded
                              : Icons.mic_none_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 3. Today's Overview Section (Heart rate + Sleep Quality cards)
              Text(
                "Today's Overview",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: _buildHeartRateCard(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 9,
                    child: _buildSleepQualityCard(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Medications Reminder Banner
              _buildMedicationBanner(),
              const SizedBox(height: 22),

              // 5. Upcoming Appointment Card (Dr. Sarah Lee - Exact Reference Style)
              Text(
                'Upcoming Appointment',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              _buildUpcomingAppointmentCard(upcomingDoctor),
              const SizedBox(height: 24),

              // 6. Find Doctors & Specialty Filter Chips (Required Coursework Features)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Find Specialist',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    '${doctors.length} available',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _specialties.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
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
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.deepOlive
                              : AppColors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.deepOlive
                                : AppColors.sageGreen.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            specialty,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkText,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // 7. Doctor Directory List
              if (doctors.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildDoctorDirectoryCard(doctors[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // كارت نبضات القلب (Heart rate 76 bpm)
  Widget _buildHeartRateCard() {
    return Container(
      height: 138,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOlive.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
                  height: 50,
                  child: CustomPaint(
                    painter: EcgWavePainter(),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                        fontSize: 15,
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

  // كارت جودة النوم (Sleep Quality 7h 24m)
  Widget _buildSleepQualityCard() {
    return Container(
      height: 138,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageLight,
            AppColors.sageGreen.withValues(alpha: 0.55),
          ],
        ),
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
                  color: AppColors.white,
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
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  // كارت التذكير بالدواء (Medications Reminder)
  Widget _buildMedicationBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightTerracotta.withValues(alpha: 0.7),
            AppColors.sageLight.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white),
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
                      color: AppColors.white,
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
              const SizedBox(height: 6),
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
              color: AppColors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.vaccines_outlined,
              color: AppColors.deepOlive,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // كارت الموعد القادم (Dr. Sarah Lee) مطابق للريفرنس
  Widget _buildUpcomingAppointmentCard(Doctor doctor) {
    return GestureDetector(
      onTap: () => _onDoctorSelected(doctor),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOlive.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.specialty,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.mutedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.darkText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tomorrow, 4:30 PM',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.darkText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sageLight.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Video Consultation',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // صورة الطبيب مع زر السهم الأسود الدائري في الزاوية
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 105,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.sageLight.withValues(alpha: 0.5),
                        AppColors.sageGreen.withValues(alpha: 0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 68,
                    color: AppColors.deepOlive,
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.nearBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.north_east_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // كارت الطبيب في قائمة البحث والفلترة
  Widget _buildDoctorDirectoryCard(Doctor doctor) {
    return GestureDetector(
      onTap: () => _onDoctorSelected(doctor),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.sageLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.sageLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.deepOlive,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.specialty,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.terracotta,
                    ),
                  ),
                  Text(
                    doctor.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sageLight.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              doctor.rating.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: AppColors.deepOlive,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${doctor.experienceYears}+ yrs exp',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${doctor.consultationFee.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  '/session',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.nearBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.north_east_rounded,
                    size: 15,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
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

// رسام خط تخطيط نبضات القلب (ECG Waveform) كما في الريفرنس
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