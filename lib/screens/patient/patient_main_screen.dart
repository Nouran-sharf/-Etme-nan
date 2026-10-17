import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'home_screen.dart';

class PatientMainScreen extends StatefulWidget {
  const PatientMainScreen({super.key});

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // محتوى الشاشة الحالية
          Positioned.fill(
            child: _buildCurrentTab(),
          ),

          // شريط التنقل السفلي العائم (مطابق للريفرنس)
          Positioned(
            left: 22,
            right: 22,
            bottom: 20,
            child: _buildReferenceFloatingDock(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return _buildPlaceholderTab(
          icon: Icons.calendar_month_rounded,
          title: 'My Appointments',
          subtitle: 'Manage your upcoming and past clinic visits here.',
        );
      case 2:
        return _buildPlaceholderTab(
          icon: Icons.person_outline_rounded,
          title: 'Patient Profile',
          subtitle: 'View and edit your personal profile details.',
        );
      default:
        return const HomeScreen();
    }
  }

  // الـ Floating Dock الدائري الموجود أسفل الشاشة الأولى في الريفرنس
  Widget _buildReferenceFloatingDock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.sageLight.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOlive.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleNavButton(
            index: 0,
            icon: Icons.home_rounded,
            tooltip: 'Home',
          ),
          _buildCircleNavButton(
            index: 1,
            icon: Icons.calendar_today_rounded,
            tooltip: 'Appointments',
          ),
          _buildCircleNavButton(
            index: 2,
            icon: Icons.person_outline_rounded,
            tooltip: 'Profile',
          ),
          // زر تبديل الدور للعودة لشاشة Patient/Admin
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Tooltip(
              message: 'Switch Role',
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.lightTerracotta,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.terracotta,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleNavButton({
    required int index,
    required IconData icon,
    required String tooltip,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Tooltip(
        message: tooltip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.deepOlive : AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.deepOlive.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.white : AppColors.darkText,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.sageLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 38, color: AppColors.deepOlive),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}