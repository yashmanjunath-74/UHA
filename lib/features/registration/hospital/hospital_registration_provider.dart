import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../auth/repository/auth_repository.dart';
import '../../auth/controller/auth_controller.dart';
import '../../hospital/repository/hospital_repository.dart';

class HospitalRegState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  // Profile
  final String institutionName;
  final String institutionType;
  final String contactNumber;
  final String officialEmail;
  final File? registrationDocument;

  // Infra
  final int bedCapacity;
  final int departments;
  final bool hasEmergency;
  final bool hasAmbulance;
  final bool hasICU;

  // Admin
  final String adminName;
  final String adminEmail;
  final String password;

  HospitalRegState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.institutionName = '',
    this.institutionType = 'General Hospital',
    this.contactNumber = '',
    this.officialEmail = '',
    this.registrationDocument,
    this.bedCapacity = 50,
    this.departments = 5,
    this.hasEmergency = true,
    this.hasAmbulance = true,
    this.hasICU = true,
    this.adminName = '',
    this.adminEmail = '',
    this.password = '',
  });

  HospitalRegState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    String? institutionName,
    String? institutionType,
    String? contactNumber,
    String? officialEmail,
    File? registrationDocument,
    int? bedCapacity,
    int? departments,
    bool? hasEmergency,
    bool? hasAmbulance,
    bool? hasICU,
    String? adminName,
    String? adminEmail,
    String? password,
  }) {
    return HospitalRegState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      institutionName: institutionName ?? this.institutionName,
      institutionType: institutionType ?? this.institutionType,
      contactNumber: contactNumber ?? this.contactNumber,
      officialEmail: officialEmail ?? this.officialEmail,
      registrationDocument: registrationDocument ?? this.registrationDocument,
      bedCapacity: bedCapacity ?? this.bedCapacity,
      departments: departments ?? this.departments,
      hasEmergency: hasEmergency ?? this.hasEmergency,
      hasAmbulance: hasAmbulance ?? this.hasAmbulance,
      hasICU: hasICU ?? this.hasICU,
      adminName: adminName ?? this.adminName,
      adminEmail: adminEmail ?? this.adminEmail,
      password: password ?? this.password,
    );
  }
}

class HospitalRegNotifier extends Notifier<HospitalRegState> {
  late final AuthRepository _authRepository;
  late final HospitalRepository _hospitalRepository;

  @override
  HospitalRegState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _hospitalRepository = ref.read(hospitalRepositoryProvider);
    return HospitalRegState();
  }

  void updateProfile({
    String? institutionName,
    String? institutionType,
    String? contactNumber,
    String? officialEmail,
    File? document,
  }) {
    state = state.copyWith(
      institutionName: institutionName,
      institutionType: institutionType,
      contactNumber: contactNumber,
      officialEmail: officialEmail,
      registrationDocument: document,
    );
  }

  void updateInfra({
    int? bedCapacity,
    int? departments,
    bool? hasEmergency,
    bool? hasAmbulance,
    bool? hasICU,
  }) {
    state = state.copyWith(
      bedCapacity: bedCapacity,
      departments: departments,
      hasEmergency: hasEmergency,
      hasAmbulance: hasAmbulance,
      hasICU: hasICU,
    );
  }

  void updateAdmin({
    String? adminName,
    String? adminEmail,
    String? password,
  }) {
    state = state.copyWith(
      adminName: adminName,
      adminEmail: adminEmail,
      password: password,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (state.adminEmail.isEmpty || state.password.isEmpty) {
        throw Exception("Admin email and password are required.");
      }

      // Step 1: Sign up the Admin user (Supabase Auth)
      final signUpRes = await _authRepository.signUp(
        email: state.adminEmail,
        password: state.password,
      );

      if (signUpRes.user == null) {
        throw Exception("Registration failed in Auth step.");
      }
      final userId = signUpRes.user!.id;

      // Step 2: Update users table with 'hospital' role and unapproved status
      await _authRepository.updateProfile(
        uid: userId,
        firstName: state.adminName,
        lastName: '',
        role: 'hospital',
      );
      // Ensure they go to waiting approval by making them unapproved initially
      await _authRepository.updateUserApproval(userId, false);

      // Step 3: Upload Document if selected
      String? uploadedDocUrl;
      if (state.registrationDocument != null) {
        uploadedDocUrl = await _hospitalRepository.uploadDocument(userId, state.registrationDocument!);
      }

      // Step 4: Insert Hospital details
      await _hospitalRepository.registerHospital(
        id: userId,
        institutionName: state.institutionName,
        institutionType: state.institutionType,
        contactNumber: state.contactNumber,
        officialEmail: state.officialEmail,
        bedCapacity: state.bedCapacity,
        departments: state.departments,
        hasEmergency: state.hasEmergency,
        hasAmbulance: state.hasAmbulance,
        hasICU: state.hasICU,
        documentUrl: uploadedDocUrl,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final hospitalRegProvider = NotifierProvider<HospitalRegNotifier, HospitalRegState>(() {
  return HospitalRegNotifier();
});
