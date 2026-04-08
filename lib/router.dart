import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'core/constants/constants.dart';

// Splash & Auth
import 'features/splash/splash_screen.dart';
import 'features/common/role_selection/role_selection_gateway.dart';
import 'features/common/role_selection/role_selection_grid.dart';
import 'features/auth/login/universal_login_screen.dart';

// Registration
import 'features/registration/basic_info_screen.dart';
import 'features/registration/verification_screen.dart';
import 'features/registration/verification_status_screen.dart';
import 'features/auth/registration/patient_registration_screen.dart';
import 'features/registration/doctor/doctor_profile_screen.dart';
import 'features/registration/doctor/doctor_credentials_screen.dart';
import 'features/registration/doctor/doctor_security_screen.dart';
import 'features/registration/hospital/hospital_profile_screen.dart';
import 'features/registration/hospital/hospital_infrastructure_screen.dart';
import 'features/registration/hospital/hospital_admin_screen.dart';
import 'features/registration/lab/lab_profile_screen.dart';
import 'features/registration/lab/lab_certifications_screen.dart';
import 'features/registration/lab/lab_admin_screen.dart';
import 'features/registration/lab/lab_facility_details_screen.dart';
import 'features/registration/lab/lab_admin_bank_screen.dart';
import 'features/registration/lab/lab_verification_status_screen.dart';
import 'features/registration/pharmacy/pharmacy_upload_screen.dart';
import 'features/registration/pharmacy/pharmacy_business_details_screen.dart';
import 'features/registration/pharmacy/pharmacy_payout_setup_screen.dart';
import 'features/common/success/registration_success_screen.dart';

// Patient Dashboard
import 'features/patient/home/patient_home_hub.dart';
import 'features/patient/medical_records/patient_digital_file_view.dart';
import 'features/patient/medical_records/medical_health_timeline.dart';
import 'features/patient/triage/ai_symptom_triage_chat.dart';
import 'features/patient/appointments/book_appointments_screen.dart';

// Doctor Dashboard
import 'features/doctor/dashboard/doctor_dashboard_shell.dart';

import 'features/doctor/roster/doctor_roster_management.dart';
import 'features/doctor/prescription/e_prescription_pad_view.dart';

// Hospital Dashboard
import 'features/hospital/dashboard/hospital_admin_overview.dart';

// Lab Dashboard
import 'features/lab/dashboard/lab_dashboard_shell.dart';

import 'features/lab/dashboard/lab_result_upload_screen.dart';

// Pharmacy Dashboard
import 'features/pharmacy/dashboard/pharmacy_dashboard_shell.dart';
import 'features/pharmacy/dashboard/pharmacy_order_queue.dart';
import 'features/pharmacy/fulfillment/pharmacy_order_fulfillment.dart';
import 'features/pharmacy/inventory/inventory_management_dashboard.dart';
import 'features/pharmacy/finance/pharmacy_earnings.dart';

// Admin Dashboard
import 'features/admin/admin_dashboard_screen.dart';
import 'features/auth/waiting_approval_screen.dart';

// Common
import 'features/common/search/doctor_search_results.dart';
import 'features/common/payment/booking_payment_confirm.dart';
import 'features/common/debug/design_viewer_screen.dart';


// Shared Public Routes (Login, Registration, Role Selection)
final _publicRoutes = {
  AppConstants.routeLogin: (_) => const MaterialPage(child: UniversalLoginScreen()),
  AppConstants.routeRoleSelection: (_) => const MaterialPage(child: RoleSelectionGatewayScreen()),
  AppConstants.routeRoleSelectionGrid: (_) => const MaterialPage(child: RoleSelectionGridScreen()),
  AppConstants.routeRegBasic: (_) => const MaterialPage(child: BasicInfoScreen()),
  AppConstants.routeRegVerification: (_) => const MaterialPage(child: VerificationScreen()),
  AppConstants.routeRegVerificationPending: (_) => const MaterialPage(child: VerificationStatusScreen()),
  AppConstants.routeRegSuccess: (_) => const MaterialPage(child: RegistrationSuccessScreen()),
  AppConstants.routeRegPatient: (_) => const MaterialPage(child: PatientRegistrationScreen()),
  AppConstants.routeRegDoctorProfile: (_) => const MaterialPage(child: DoctorProfileScreen()),
  AppConstants.routeRegDoctorCredentials: (_) => const MaterialPage(child: DoctorCredentialsScreen()),
  AppConstants.routeRegDoctorSecurity: (_) => const MaterialPage(child: DoctorSecurityScreen()),
  AppConstants.routeRegHospitalProfile: (_) => const MaterialPage(child: HospitalProfileScreen()),
  AppConstants.routeRegHospitalInfra: (_) => const MaterialPage(child: HospitalInfrastructureScreen()),
  AppConstants.routeRegHospitalAdmin: (_) => const MaterialPage(child: HospitalAdminScreen()),
  AppConstants.routeRegLabProfile: (_) => const MaterialPage(child: LabProfileScreen()),
  AppConstants.routeRegLabCertifications: (_) => const MaterialPage(child: LabCertificationsScreen()),
  AppConstants.routeRegLabAdmin: (_) => const MaterialPage(child: LabAdminScreen()),
  AppConstants.routeRegLabFacility: (_) => const MaterialPage(child: LabFacilityDetailsScreen()),
  AppConstants.routeRegLabBank: (_) => const MaterialPage(child: LabAdminBankScreen()),
  AppConstants.routeRegLabVerification: (_) => const MaterialPage(child: LabVerificationStatusScreen()),
  AppConstants.routeRegPharmacyUpload: (_) => const MaterialPage(child: PharmacyUploadScreen()),
  AppConstants.routeRegPharmacyBusiness: (_) => const MaterialPage(child: PharmacyBusinessDetailsScreen()),
  AppConstants.routeRegPharmacyPayout: (_) => const MaterialPage(child: PharmacyPayoutSetupScreen()),
};

/// Centralized Routemaster route map.
final appRouter = RouteMap(
  routes: {
    AppConstants.routeSplash: (_) => const MaterialPage(child: SplashScreen()),
    '/design_viewer': (_) => const MaterialPage(child: DesignViewerScreen()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: PatientHomeHub()),
    ..._publicRoutes,

    // ── Patient Features ──────────────────────────────────────────────────
    AppConstants.routePatientHome: (_) => const MaterialPage(child: PatientHomeHub()),
    AppConstants.routePatientDigitalFile: (_) => const MaterialPage(child: PatientDigitalFileView()),
    AppConstants.routePatientTimeline: (_) => const MaterialPage(child: MedicalHealthTimeline()),
    AppConstants.routePatientTriage: (_) => const MaterialPage(child: AISymptomTriageChat()),
    AppConstants.routeBookAppointment: (_) => const MaterialPage(child: BookAppointmentsScreen()),
    AppConstants.routeSearchDoctors: (_) => const MaterialPage(child: DoctorSearchResults()),
    AppConstants.routeBookingPayment: (_) => const MaterialPage(child: BookingPaymentConfirm()),
  },
);

final adminRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: AdminDashboardScreen()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: AdminDashboardScreen()),
    AppConstants.routeWaitingApproval: (_) => const MaterialPage(child: WaitingApprovalScreen()),
    ..._publicRoutes,
  },
);

final unapprovedRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: WaitingApprovalScreen()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: WaitingApprovalScreen()),
    ..._publicRoutes,
  },
);

final hospitalRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HospitalAdminOverview()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: HospitalAdminOverview()),
    ..._publicRoutes,
  },
);

final doctorRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: DoctorDashboardShell()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: DoctorDashboardShell()),
    AppConstants.routeDoctorRoster: (_) => const MaterialPage(child: DoctorRosterManagement()),
    '${AppConstants.routeDoctorPrescription}/:pid': (info) => MaterialPage(child: EPrescriptionPadView(patientId: info.pathParameters['pid'] ?? '')),
    ..._publicRoutes,
  },
);

final labRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LabDashboardShell()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: LabDashboardShell()),
    AppConstants.routeLabUploadResult: (_) => const MaterialPage(child: LabResultUploadScreen()),
    ..._publicRoutes,
  },
);

final pharmacyRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: PharmacyDashboardShell()),
    AppConstants.routeDashboard: (_) => const MaterialPage(child: PharmacyDashboardShell()),
    AppConstants.routePharmacyOrders: (_) => const MaterialPage(child: PharmacyOrderQueue()),
    AppConstants.routePharmacyFulfillment: (_) => const MaterialPage(child: PharmacyOrderFulfillment()),
    AppConstants.routePharmacyInventory: (_) => const MaterialPage(child: InventoryManagementDashboard()),
    AppConstants.routePharmacyEarnings: (_) => const MaterialPage(child: PharmacyEarnings()),
    ..._publicRoutes,
  },
);

