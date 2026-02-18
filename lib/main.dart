import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/role_selection/role_selection_gateway.dart';
import 'features/role_selection/role_selection_grid.dart';
import 'features/auth/login/universal_login_screen.dart';
import 'features/registration/basic_info_screen.dart';
import 'features/registration/verification_screen.dart';
import 'features/auth/registration/patient_registration_screen.dart';

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
import 'features/registration/lab/lab_facility_details_screen.dart';
import 'features/registration/lab/lab_admin_bank_screen.dart';
import 'features/registration/pharmacy/pharmacy_upload_screen.dart';
import 'features/registration/pharmacy/pharmacy_business_details_screen.dart';
import 'features/registration/pharmacy/pharmacy_payout_setup_screen.dart';
import 'features/premium_dashboard/screens/premium_health_dashboard.dart';

// Patient Features
import 'features/patient/home/patient_home_hub.dart';
import 'features/patient/medical_records/patient_digital_file_view.dart';
import 'features/patient/medical_records/medical_health_timeline.dart';
import 'features/patient/triage/ai_symptom_triage_chat.dart';

// Doctor Features
import 'features/doctor/dashboard/doctor_schedule_dashboard.dart';
import 'features/doctor/roster/doctor_roster_management.dart';
import 'features/doctor/prescription/e_prescription_pad_view.dart';

// Pharmacy Features
import 'features/pharmacy/dashboard/pharmacy_order_queue.dart';
import 'features/pharmacy/fulfillment/pharmacy_order_fulfillment.dart';
import 'features/pharmacy/inventory/inventory_management_dashboard.dart';
import 'features/pharmacy/finance/pharmacy_earnings.dart';

// Hospital & Common Features
import 'features/hospital/dashboard/hospital_admin_overview.dart';
import 'features/common/search/doctor_search_results.dart';
import 'features/common/payment/booking_payment_confirm.dart';
import 'features/common/success/registration_success_screen.dart';
import 'features/common/debug/design_viewer_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'core/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Initialize Google Sign-In
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  // We don't await this as per user snippet example (unawaited), or we can await it.
  // Using await to be safe against race conditions on startup.
  await googleSignIn.initialize(
    clientId: SupabaseConfig.googleClientId,
    serverClientId: SupabaseConfig.googleServerClientId,
  );

  runApp(const ProviderScope(child: UnifiedHealthAllianceApp()));
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
        '/design_viewer': (context) => const DesignViewerScreen(),
        '/role_selection': (context) => const RoleSelectionGatewayScreen(),
        '/role_selection_grid': (context) => const RoleSelectionGridScreen(),
        '/login': (context) => const UniversalLoginScreen(),
        '/dashboard': (context) => const PremiumHealthDashboard(),
        '/registration/basic': (context) => const BasicInfoScreen(),
        '/registration/verification': (context) => const VerificationScreen(),
        '/registration/patient': (context) => const PatientRegistrationScreen(),
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
        '/registration/lab_facility': (context) =>
            const LabFacilityDetailsScreen(),
        '/registration/lab_bank': (context) => const LabAdminBankScreen(),
        '/registration/pharmacy_upload': (context) =>
            const PharmacyUploadScreen(),
        '/registration/pharmacy_business': (context) =>
            const PharmacyBusinessDetailsScreen(),
        '/registration/pharmacy_payout': (context) =>
            const PharmacyPayoutSetupScreen(),

        // Patient Routes
        '/patient/home': (context) => const PatientHomeHub(),
        '/patient/digital_file': (context) => const PatientDigitalFileView(),
        '/patient/timeline': (context) => const MedicalHealthTimeline(),
        '/patient/triage': (context) => const AISymptomTriageChat(),

        // Doctor Routes
        '/doctor/dashboard': (context) => const DoctorScheduleDashboard(),
        '/doctor/roster': (context) => const DoctorRosterManagement(),
        '/doctor/prescription': (context) => const EPrescriptionPadView(),

        // Pharmacy Routes
        '/pharmacy/orders': (context) => const PharmacyOrderQueue(),
        '/pharmacy/fulfillment': (context) => const PharmacyOrderFulfillment(),
        '/pharmacy/inventory': (context) =>
            const InventoryManagementDashboard(),
        '/pharmacy/earnings': (context) => const PharmacyEarnings(),

        // Hospital & Common Routes
        '/hospital/dashboard': (context) => const HospitalAdminOverview(),
        '/search/doctors': (context) => const DoctorSearchResults(),
        '/booking/payment': (context) => const BookingPaymentConfirm(),
        '/success': (context) => const RegistrationSuccessScreen(),
      },
    );
  }
}
