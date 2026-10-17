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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

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
          MaterialPageRoute(
            builder: (context) => const PatientMainScreen(),
          ),
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
          // خلفية متدرجة ناعمة مستوحاة من الريفرنس
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.sageLight.withValues(alpha: 0.7),
                    AppColors.cream,
                    AppColors.cream,
                  ],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: CustomPaint(
              painter: OrganicBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Badge علوي شبيه بالريفرنس
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.sageGreen.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'Smart HealthCare',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepOlive,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // أيقونة عضوية مركزية
                        Center(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.white,
                                  AppColors.sageLight,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.deepOlive.withValues(alpha: 0.12),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.spa_rounded,
                                size: 46,
                                color: AppColors.deepOlive,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // العنوان الرئيسي بنفس روح الريفرنس
                        Text(
                          'How can we help\nyou today?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            height: 1.25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Get instant healthcare access — simple, fast,\nand tailored to your role.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.mutedText,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 34),

                        // كروت الأدوار بتصميم Bento Grid / Reference Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildBentoRoleCard(
                                roleName: 'Patient',
                                description:
                                    'Book visits, check vitals & consult doctors',
                                icon: Icons.favorite_outline_rounded,
                                accentColor: AppColors.deepOlive,
                                cardBg: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildBentoRoleCard(
                                roleName: 'Admin',
                                description:
                                    'Manage doctor directory & clinic slots',
                                icon: Icons.shield_outlined,
                                accentColor: AppColors.terracotta,
                                cardBg: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // شريط سفلي داكن أنيق يحاكي شريط الريفرنس الأسود
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.nearBlack,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkText.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.sageLight,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Demo Mode: Select a role to preview interface',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: AppColors.cream,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.north_east_rounded,
                                color: AppColors.terracotta,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoRoleCard({
    required String roleName,
    required String description,
    required IconData icon,
    required Color accentColor,
    required Color cardBg,
  }) {
    final bool isSelected = selectedRole == roleName;

    return GestureDetector(
      onTap: () => _handleRoleSelect(roleName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.all(18),
        height: 195,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.sageLight.withValues(alpha: 0.85)
              : cardBg.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? accentColor
                : AppColors.sageGreen.withValues(alpha: 0.35),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOlive.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // الصف العلوي: أيقونة يسار + سهم دائري يمين (مثل الشاشة الوسطى بالريفرنس)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.nearBlack : AppColors.cream,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.north_east_rounded,
                    size: 17,
                    color: isSelected ? AppColors.white : AppColors.darkText,
                  ),
                ),
              ],
            ),
            // النص السفلي
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roleName,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    height: 1.35,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrganicBackgroundPainter extends CustomPainter {
  const OrganicBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint sagePaint = Paint()
      ..color = AppColors.sageGreen.withValues(alpha: 0.18);
    final Paint terracottaPaint = Paint()
      ..color = AppColors.terracotta.withValues(alpha: 0.10);

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      90,
      sagePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.12, size.height * 0.82),
      110,
      terracottaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}