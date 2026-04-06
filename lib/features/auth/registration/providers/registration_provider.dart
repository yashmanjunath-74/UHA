import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/auth_controller.dart';
import '../../repository/auth_repository.dart';
import '../../../../features/patient/controller/patient_controller.dart';

class RegistrationState {
  final int currentStep;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  // Step 1: Basic Info
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String gender; // 'Male', 'Female', 'Other'
  final String bloodGroup;
  final XFile? profilePhoto;

  // Step 2: Verification
  final String nationalId;
  final XFile? idProofImage;

  // Step 3: Security
  final String email;
  final String password;
  final bool isGoogleAuth;

  RegistrationState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender = 'Male',
    this.bloodGroup = 'O+',
    this.profilePhoto,
    this.nationalId = '',
    this.idProofImage,
    this.email = '',
    this.password = '',
    this.isGoogleAuth = false,
  });

  RegistrationState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    XFile? profilePhoto,
    String? nationalId,
    XFile? idProofImage,
    String? email,
    String? password,
    bool? isGoogleAuth,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      nationalId: nationalId ?? this.nationalId,
      idProofImage: idProofImage ?? this.idProofImage,
      email: email ?? this.email,
      password: password ?? this.password,
      isGoogleAuth: isGoogleAuth ?? this.isGoogleAuth,
    );
  }

  double get progress {
    return (currentStep + 1) / 3.0;
  }
}

class RegistrationNotifier extends Notifier<RegistrationState> {
  late final AuthRepository _authRepository;

  @override
  RegistrationState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return RegistrationState();
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // Update Data Methods
  void updateBasicInfo({
    String? firstName,
    String? lastName,
    DateTime? dob,
    String? gender,
    String? bloodGroup,
    XFile? photo,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      profilePhoto: photo,
    );
  }

  void updateVerification({String? nationalId, XFile? proof}) {
    state = state.copyWith(nationalId: nationalId, idProofImage: proof);
  }

  void updateSecurity({String? email, String? password, bool? isGoogle}) {
    state = state.copyWith(
      email: email,
      password: password,
      isGoogleAuth: isGoogle,
    );
  }

  Future<void> submitRegistration() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      String? userId;

      if (state.isGoogleAuth) {
        // User already authenticated via Google in Step 3 button
        final currentUser = _authRepository.currentUser;
        if (currentUser == null) {
          throw Exception('Google Auth not completed. Please sign in again.');
        }
        userId = currentUser.id;
      } else {
        // Email / Password Sign Up
        if (state.email.isEmpty || state.password.isEmpty) {
          throw Exception('Email and Password are required.');
        }
        final response = await _authRepository.signUp(
          email: state.email,
          password: state.password,
          data: {
            'full_name': '${state.firstName} ${state.lastName}',
            'role': 'patient',
          },
        );
        if (response.user == null) {
          throw Exception('Sign up failed. Please try again.');
        }
        userId = response.user!.id;
      }

      await _authRepository.updateProfile(
        uid: userId,
        firstName: state.firstName,
        lastName: state.lastName,
        role: 'patient',
        nationalId: state.nationalId,
        gender: state.gender,
        dob: state.dateOfBirth,
      );

      // Create Patient entry in 'patients' table
      await ref.read(patientRegistrationProvider.notifier).registerPatient(
        userId: userId,
        dateOfBirth: state.dateOfBirth?.toIso8601String().split(' ')[0] ?? '',
        gender: state.gender,
        bloodGroup: state.bloodGroup,
        allergies: [],
        chronicConditions: [],
        emergencyContactName: '',
        emergencyContactPhone: '',
      );

      // Check if the patient insertion failed
      final patientState = ref.read(patientRegistrationProvider);
      if (patientState.hasError) {
        throw Exception(patientState.error.toString());
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(() {
      return RegistrationNotifier();
    });
