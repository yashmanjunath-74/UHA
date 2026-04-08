/// App-wide string constants: route paths, Supabase table names, asset paths.
class AppConstants {
  AppConstants._();

  // ── Route paths ─────────────────────────────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeRoleSelection = '/role-selection';
  static const String routeRoleSelectionGrid = '/role-selection/grid';
  static const String routeLogin = '/login';
  static const String routeDashboard = '/dashboard';

  // Registration
  static const String routeRegBasic = '/registration/basic';
  static const String routeRegVerification = '/registration/verification';
  static const String routeRegVerificationPending = '/registration/verification-pending';
  static const String routeRegSuccess = '/registration/success';

  static const String routeRegPatient = '/registration/patient';
  static const String routeRegDoctorProfile = '/registration/doctor/profile';
  static const String routeRegDoctorCredentials = '/registration/doctor/credentials';
  static const String routeRegDoctorSecurity = '/registration/doctor/security';

  static const String routeRegHospitalProfile = '/registration/hospital/profile';
  static const String routeRegHospitalInfra = '/registration/hospital/infrastructure';
  static const String routeRegHospitalAdmin = '/registration/hospital/admin';

  static const String routeRegLabProfile = '/registration/lab/profile';
  static const String routeRegLabCertifications = '/registration/lab/certifications';
  static const String routeRegLabAdmin = '/registration/lab/admin';
  static const String routeRegLabFacility = '/registration/lab/facility';
  static const String routeRegLabBank = '/registration/lab/bank';
  static const String routeRegLabVerification = '/registration/lab/verification';

  static const String routeRegPharmacyUpload = '/registration/pharmacy/upload';
  static const String routeRegPharmacyBusiness = '/registration/pharmacy/business';
  static const String routeRegPharmacyPayout = '/registration/pharmacy/payout';

  // Patient dashboard
  static const String routePatientHome = '/patient/home';
  static const String routePatientDigitalFile = '/patient/digital-file';
  static const String routePatientTimeline = '/patient/timeline';
  static const String routePatientTriage = '/patient/triage';

  // Doctor dashboard
  static const String routeDoctorDashboard = '/doctor/dashboard';
  static const String routeDoctorRoster = '/doctor/roster';
  static const String routeDoctorPrescription = '/doctor/prescription';

  // Hospital dashboard
  static const String routeHospitalDashboard = '/hospital/dashboard';

  // Lab dashboard
  static const String routeLabDashboard = '/lab/dashboard';
  static const String routeLabUploadResult = '/lab/upload-result';

  // Pharmacy dashboard
  static const String routePharmacyOrders = '/pharmacy/orders';
  static const String routePharmacyFulfillment = '/pharmacy/fulfillment';
  static const String routePharmacyInventory = '/pharmacy/inventory';
  static const String routePharmacyEarnings = '/pharmacy/earnings';

  // Common
  static const String routeSearchDoctors = '/search/doctors';
  static const String routeBookAppointment = '/book-appointment';
  static const String routeBookingPayment = '/booking/payment';

  // Admin
  static const String routeAdminDashboard = '/admin/dashboard';
  static const String routeWaitingApproval = '/auth/waiting-approval';

  // ── Supabase table names ─────────────────────────────────────────────────────
  static const String tableUsers = 'users';
  static const String tablePatients = 'patients';
  static const String tableDoctors = 'doctors';
  static const String tableHospitals = 'hospitals';
  static const String tableLabs = 'labs';
  static const String tablePharmacies = 'pharmacies';
}
