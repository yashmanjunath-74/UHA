import 'package:flutter_riverpod/flutter_riverpod.dart';

class LabRegistrationState {
  final bool isLoading;
  final String? error;
  final int currentStep;

  // Step 1: Facility Details
  final String? labName;
  final String? category;
  final String? nablNumber;
  final String? headOfLab;

  // Step 2: Certifications & Services
  final String? services;
  final String? nablFilePath;
  final String? healthPermitFilePath;

  // Step 3: Admin & Bank Setup
  final String? adminEmail;
  final String? mobileNumber;
  final bool isOtpVerified;
  final String? bankName;
  final String? accountHolder;
  final String? accountNumber;
  final String? routingCode;
  final bool agreedToTerms;

  LabRegistrationState({
    this.isLoading = false,
    this.error,
    this.currentStep = 1,
    this.labName,
    this.category,
    this.nablNumber,
    this.headOfLab,
    this.services,
    this.nablFilePath,
    this.healthPermitFilePath,
    this.adminEmail,
    this.mobileNumber,
    this.isOtpVerified = false,
    this.bankName,
    this.accountHolder,
    this.accountNumber,
    this.routingCode,
    this.agreedToTerms = false,
  });

  LabRegistrationState copyWith({
    bool? isLoading,
    String? error,
    int? currentStep,
    String? labName,
    String? category,
    String? nablNumber,
    String? headOfLab,
    String? services,
    String? nablFilePath,
    String? healthPermitFilePath,
    String? adminEmail,
    String? mobileNumber,
    bool? isOtpVerified,
    String? bankName,
    String? accountHolder,
    String? accountNumber,
    String? routingCode,
    bool? agreedToTerms,
  }) {
    return LabRegistrationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentStep: currentStep ?? this.currentStep,
      labName: labName ?? this.labName,
      category: category ?? this.category,
      nablNumber: nablNumber ?? this.nablNumber,
      headOfLab: headOfLab ?? this.headOfLab,
      services: services ?? this.services,
      nablFilePath: nablFilePath ?? this.nablFilePath,
      healthPermitFilePath: healthPermitFilePath ?? this.healthPermitFilePath,
      adminEmail: adminEmail ?? this.adminEmail,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      bankName: bankName ?? this.bankName,
      accountHolder: accountHolder ?? this.accountHolder,
      accountNumber: accountNumber ?? this.accountNumber,
      routingCode: routingCode ?? this.routingCode,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    );
  }
}

final labRegistrationProvider =
    NotifierProvider<LabRegistrationController, LabRegistrationState>(
      LabRegistrationController.new,
    );

class LabRegistrationController extends Notifier<LabRegistrationState> {
  @override
  LabRegistrationState build() {
    return LabRegistrationState();
  }

  void updateField({
    String? labName,
    String? category,
    String? nablNumber,
    String? headOfLab,
    String? services,
    String? adminEmail,
    String? mobileNumber,
    String? bankName,
    String? accountHolder,
    String? accountNumber,
    String? routingCode,
    bool? agreedToTerms,
  }) {
    state = state.copyWith(
      labName: labName,
      category: category,
      nablNumber: nablNumber,
      headOfLab: headOfLab,
      services: services,
      adminEmail: adminEmail,
      mobileNumber: mobileNumber,
      bankName: bankName,
      accountHolder: accountHolder,
      accountNumber: accountNumber,
      routingCode: routingCode,
      agreedToTerms: agreedToTerms,
    );
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> uploadFile(String type, String path) async {
    state = state.copyWith(isLoading: true);
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 1));

    if (type == 'nabl') {
      state = state.copyWith(isLoading: false, nablFilePath: path);
    } else if (type == 'permit') {
      state = state.copyWith(isLoading: false, healthPermitFilePath: path);
    }
  }

  Future<void> sendOtp() async {
    state = state.copyWith(isLoading: true);
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }

  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true);
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false, isOtpVerified: true);
  }

  Future<bool> submitRegistration() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Simulate submission
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
