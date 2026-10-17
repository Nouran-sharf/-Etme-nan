import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(const SmartHealthcareApp());
}

class SmartHealthcareApp extends StatelessWidget {
  const SmartHealthcareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart HealthCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoleSelectionScreen(),
    );
  }
}