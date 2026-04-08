import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/supabase_provider.dart';
import '../../../models/patient_model.dart';
import '../../../models/appointment_model.dart';
import '../../../models/medical_record_model.dart';
import '../repository/patient_repository.dart';
import '../repository/appointment_repository.dart';
import '../repository/medical_record_repository.dart';

// Patient Repository Providers
final patientRepositoryProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return PatientRepository(supabaseClient: supabaseClient);
});

final appointmentRepositoryProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AppointmentRepository(supabaseClient: supabaseClient);
});

final medicalRecordRepositoryProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return MedicalRecordRepository(supabaseClient: supabaseClient);
});

// Patient Profile Provider
final patientProfileProvider = FutureProvider.family<PatientModel, String>((ref, userId) async {
  final repository = ref.watch(patientRepositoryProvider);
  final result = await repository.fetchPatientProfile(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (patient) => patient,
  );
});

// Patient Appointments Provider
final patientAppointmentsProvider = FutureProvider.family<List<AppointmentModel>, String>((ref, patientId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  final result = await repository.fetchPatientAppointments(patientId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (appointments) => appointments,
  );
});

// Patient Medical Records Provider
final patientMedicalRecordsProvider = FutureProvider.family<List<MedicalRecordModel>, String>((ref, patientId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  final result = await repository.fetchMedicalRecords(patientId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});

// Patient Health Score Provider
final patientHealthScoreProvider = FutureProvider.family<int, String>((ref, patientId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  final result = await repository.fetchHealthScore(patientId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (score) => score,
  );
});

// Patient Registration Notifier
class PatientRegistrationNotifier extends Notifier<AsyncValue<PatientModel>> {
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
      (failure) => AsyncValue.error(Exception(failure.message), StackTrace.current),
      (patient) => AsyncValue.data(patient),
    );
  }

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
      (failure) => AsyncValue.error(Exception(failure.message), StackTrace.current),
      (patient) => AsyncValue.data(patient),
    );
  }
}

final patientRegistrationProvider = NotifierProvider<PatientRegistrationNotifier, AsyncValue<PatientModel>>(() {
  return PatientRegistrationNotifier();
});

