import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../localization/app_translations.dart';
import 'home_screen.dart';
import 'services_doctors_screen.dart';
import 'medical_centers_screen.dart';
import 'my_appointments_screen.dart';

/// Navigation shell containing 4 bottom navigation items:
/// Home, Services & Doctors, Medical Centers, and My Appointments.
class MainNavigationShell extends StatefulWidget {
  final int initialTab;

  const MainNavigationShell({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;
  String? _activeServiceFilter;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _navigateToTab(int tabIndex, {String? serviceFilter}) {
    setState(() {
      _currentIndex = tabIndex;
      _activeServiceFilter = serviceFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;

    final pages = [
      HomeScreen(
        onNavigateToTab: _navigateToTab,
      ),
      ServicesDoctorsScreen(
        initialFilter: _activeServiceFilter,
      ),
      const MedicalCentersScreen(),
      MyAppointmentsScreen(
        onNavigateToTab: _navigateToTab,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.lightBorder, width: 1.2),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
              if (index != 1) {
                _activeServiceFilter = null;
              }
            });
          },
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.softPink,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, color: AppColors.mutedText),
              selectedIcon:
                  const Icon(Icons.home_rounded, color: AppColors.primary),
              label: AppTranslations.tr('navHome', isArabic),
              tooltip: AppTranslations.tr('navHome', isArabic),
            ),
            NavigationDestination(
              icon: const Icon(Icons.medical_services_outlined,
                  color: AppColors.mutedText),
              selectedIcon: const Icon(Icons.medical_services_rounded,
                  color: AppColors.primary),
              label: AppTranslations.tr('navServices', isArabic),
              tooltip: AppTranslations.tr('navServices', isArabic),
            ),
            NavigationDestination(
              icon: const Icon(Icons.apartment_outlined,
                  color: AppColors.mutedText),
              selectedIcon:
                  const Icon(Icons.apartment_rounded, color: AppColors.primary),
              label: AppTranslations.tr('navCenters', isArabic),
              tooltip: AppTranslations.tr('navCenters', isArabic),
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined,
                  color: AppColors.mutedText),
              selectedIcon: const Icon(Icons.calendar_month_rounded,
                  color: AppColors.primary),
              label: AppTranslations.tr('navAppointments', isArabic),
              tooltip: AppTranslations.tr('navAppointments', isArabic),
            ),
          ],
        ),
      ),
    );
  }
}
