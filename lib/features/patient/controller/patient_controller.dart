import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/patient_model.dart';
import '../repository/patient_repository.dart';

// Supabase Client Provider
final supabaseClientProvider = Provider((ref) {
  return Supabase.instance.client;
});

// Patient Repository Provider
final patientRepositoryProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return PatientRepository(supabaseClient: supabaseClient);
});

// Patient Profile Provider (FutureProvider for async data fetching)
final patientProfileProvider = FutureProvider.family<PatientModel, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(patientRepositoryProvider);
  final result = await repository.fetchPatientProfile(userId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (patient) => patient,
  );
});

// Patient Registration Notifier
class PatientRegistrationNotifier
    extends Notifier<AsyncValue<PatientModel>> {
  late final PatientRepository _repository;

  @override
  AsyncValue<PatientModel> build() {
    _repository = ref.read(patientRepositoryProvider);
    return const AsyncValue.data(
      PatientModel(
        id: '',
        userId: '',
        allergies: [],
        chronicConditions: [],
      ),
    );
  }

  /// Register a new patient
  Future<void> registerPatient({
    required String userId,
    required String dateOfBirth,
    required String gender,
    required String bloodGroup,
    required List<String> allergies,
    required List<String> chronicConditions,
    required String emergencyContactName,
    required String emergencyContactPhone,
  }) async {
    state = const AsyncValue.loading();

    final result = await _repository.registerPatient(
      userId: userId,
      dateOfBirth: dateOfBirth,
      gender: gender,
      bloodGroup: bloodGroup,
      allergies: allergies,
      chronicConditions: chronicConditions,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );

    state = result.fold(
      (failure) =>
          AsyncValue.error(Exception(failure.message), StackTrace.current),
      (patient) => AsyncValue.data(patient),
    );
  }

  /// Update patient profile
  Future<void> updatePatient({
    required String userId,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    List<String>? allergies,
    List<String>? chronicConditions,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    state = const AsyncValue.loading();

    final result = await _repository.updatePatient(
      userId: userId,
      dateOfBirth: dateOfBirth,
      gender: gender,
      bloodGroup: bloodGroup,
      allergies: allergies,
      chronicConditions: chronicConditions,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );

    state = result.fold(
      (failure) =>
          AsyncValue.error(Exception(failure.message), StackTrace.current),
      (patient) => AsyncValue.data(patient),
    );
  }
}

// Patient Registration State Notifier Provider
final patientRegistrationProvider =
    NotifierProvider<
      PatientRegistrationNotifier,
      AsyncValue<PatientModel>
    >(() {
      return PatientRegistrationNotifier();
    });

