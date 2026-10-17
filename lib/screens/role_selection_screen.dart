import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'patient/patient_main_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String selectedRole = '';

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRoleSelect(String role) {
    setState(() {
      selectedRole = role;
    });

    if (role == 'Patient') {
      Future.delayed(const Duration(milliseconds: 220), () {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatientMainScreen()),
        );
      });
    } else if (role == 'Admin') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Admin Dashboard will be connected in Phase 5',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.deepOlive,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Top-to-bottom rich atmospheric gradient matching the reference flow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.68, 1.0],
                  colors: [
                    AppColors.deepOlive,
                    AppColors.sageGreen,
                    AppColors.sageLight.withValues(alpha: 0.85),
                    AppColors.cream,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Concentric Orbital Graphic (Reference Centerpiece)
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildOrbitalHeroGraphic(),
                      ),

                      const Spacer(flex: 2),

                      // Typography Section matching reference hierarchy & spacing
                      Text(
                        'How can we help\nyou today?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          height: 1.2,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Get instant healthcare access — simple, fast,\nand tailored to your role.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: AppColors.mutedText,
                            height: 1.55,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // Bottom Action Area: 2 Pill Buttons styled after the reference button
                      Row(
                        children: [
                          Expanded(
                            child: _buildPillRoleButton(
                              roleName: 'Patient',
                              icon: Icons.favorite_outline_rounded,
                              isPrimary: true,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildPillRoleButton(
                              roleName: 'Admin',
                              icon: Icons.shield_outlined,
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the multi-ring radar/orbital graphic with 6 positioned glass badges
  Widget _buildOrbitalHeroGraphic() {
    const double containerSize = 320;
    const double outerRingSize = 276;
    const double innerRingSize = 192;
    const double centerAvatarSize = 108;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Translucent Circle
          Container(
            width: outerRingSize,
            height: outerRingSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.14),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
          ),

          // Inner Translucent Circle
          Container(
            width: innerRingSize,
            height: innerRingSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.18),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.24),
                width: 1,
              ),
            ),
          ),

          // Center Healthcare Avatar Circle
          Container(
            width: centerAvatarSize,
            height: centerAvatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.white, AppColors.sageLight],
              ),
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOlive.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: -8,
                    child: Icon(
                      Icons.person_rounded,
                      size: 88,
                      color: AppColors.sageGreen.withValues(alpha: 0.35),
                    ),
                  ),
                  const Icon(
                    Icons.health_and_safety_rounded,
                    size: 46,
                    color: AppColors.deepOlive,
                  ),
                ],
              ),
            ),
          ),

          // --- Outer Ring Badges (Radius = 138) ---
          // Top Right-ish (Hospital / Location pin)
          _buildPositionedOrbitBadge(
            angleDegrees: -78,
            radius: outerRingSize / 2,
            icon: Icons.local_hospital_outlined,
          ),
          // Right (Doctor / User profile)
          _buildPositionedOrbitBadge(
            angleDegrees: 5,
            radius: outerRingSize / 2,
            icon: Icons.person_outline_rounded,
          ),
          // Bottom Left-ish (Stethoscope / Checkup)
          _buildPositionedOrbitBadge(
            angleDegrees: 100,
            radius: outerRingSize / 2,
            icon: Icons.medical_information_outlined,
          ),
          // Left (Medical Kit)
          _buildPositionedOrbitBadge(
            angleDegrees: 184,
            radius: outerRingSize / 2,
            icon: Icons.medical_services_outlined,
          ),

          // --- Inner Ring Badges (Radius = 96) ---
          // Top Left (Vitals / Lungs / Heart)
          _buildPositionedOrbitBadge(
            angleDegrees: -132,
            radius: innerRingSize / 2,
            icon: Icons.monitor_heart_outlined,
            badgeSize: 44,
          ),
          // Bottom Right (Medication / Pill)
          _buildPositionedOrbitBadge(
            angleDegrees: 45,
            radius: innerRingSize / 2,
            icon: Icons.medication_outlined,
            badgeSize: 44,
          ),
        ],
      ),
    );
  }

  /// Calculates polar coordinates to place floating frosted glass badges on the rings
  Widget _buildPositionedOrbitBadge({
    required double angleDegrees,
    required double radius,
    required IconData icon,
    double badgeSize = 48,
  }) {
    final double radians = angleDegrees * (math.pi / 180.0);
    final double dx = radius * math.cos(radians);
    final double dy = radius * math.sin(radians);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.22),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.65),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Icon(icon, size: badgeSize * 0.44, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }

  /// Clean, high-contrast pill buttons modeled after the "Get Started" reference button
  Widget _buildPillRoleButton({
    required String roleName,
    required IconData icon,
    required bool isPrimary,
  }) {
    final bool isSelected = selectedRole == roleName;

    final Color backgroundColor = isSelected
        ? AppColors.deepOlive
        : (isPrimary
              ? AppColors.white
              : AppColors.white.withValues(alpha: 0.65));

    final Color foregroundColor = isSelected
        ? AppColors.white
        : AppColors.darkText;

    return GestureDetector(
      onTap: () => _handleRoleSelect(roleName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? AppColors.deepOlive
                : AppColors.white.withValues(alpha: 0.9),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOlive.withValues(
                alpha: isSelected ? 0.22 : 0.07,
              ),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected
                  ? AppColors.sageLight
                  : (isPrimary ? AppColors.deepOlive : AppColors.terracotta),
            ),
            const SizedBox(width: 8),
            Text(
              roleName,
              style: GoogleFonts.poppins(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
