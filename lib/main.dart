import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/role_selection/role_selection_gateway.dart';
import 'features/role_selection/role_selection_grid.dart';
import 'features/auth/login_screen.dart';
import 'features/registration/basic_info_screen.dart';
import 'features/registration/verification_screen.dart';

import 'features/registration/doctor/doctor_profile_screen.dart';
import 'features/registration/doctor/doctor_credentials_screen.dart';
import 'features/registration/doctor/doctor_security_screen.dart';
import 'features/registration/verification_status_screen.dart';
import 'features/registration/hospital/hospital_profile_screen.dart';
import 'features/registration/hospital/hospital_infrastructure_screen.dart';
import 'features/registration/hospital/hospital_admin_screen.dart';
import 'features/registration/lab/lab_profile_screen.dart';
import 'features/registration/lab/lab_certifications_screen.dart';
import 'features/registration/lab/lab_admin_screen.dart';
import 'features/registration/pharmacy/pharmacy_upload_screen.dart';

void main() {
  runApp(const UnifiedHealthAllianceApp());
}

class UnifiedHealthAllianceApp extends StatelessWidget {
  const UnifiedHealthAllianceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unified Health Alliance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/role_selection': (context) => const RoleSelectionGatewayScreen(),
        '/role_selection_grid': (context) => const RoleSelectionGridScreen(),
        '/login': (context) => const UniversalLoginScreen(),
        '/registration/basic': (context) => const BasicInfoScreen(),
        '/registration/verification': (context) => const VerificationScreen(),
        // New Registration Flows
        '/registration/doctor_profile': (context) =>
            const DoctorProfileScreen(),
        '/registration/doctor_credentials': (context) =>
            const DoctorCredentialsScreen(),
        '/registration/doctor_security': (context) =>
            const DoctorSecurityScreen(),
        '/registration/verification_pending': (context) =>
            const VerificationStatusScreen(),
        '/registration/hospital_profile': (context) =>
            const HospitalProfileScreen(),
        '/registration/hospital_infrastructure': (context) =>
            const HospitalInfrastructureScreen(),
        '/registration/hospital_admin': (context) =>
            const HospitalAdminScreen(),
        '/registration/lab_profile': (context) => const LabProfileScreen(),
        '/registration/lab_certifications': (context) =>
            const LabCertificationsScreen(),
        '/registration/lab_admin': (context) => const LabAdminScreen(),
        '/registration/pharmacy_upload': (context) =>
            const PharmacyUploadScreen(),
      },
    );
  }
}
