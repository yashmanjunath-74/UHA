import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/patient_model.dart';
import '../controller/patient_controller.dart';
import '../repository/patient_repository.dart';

/// Patient Service - High-level API for patient operations
class PatientService {
  final PatientRepository _repository;

  PatientService(this._repository);

  /// Complete patient registration with all required information
  Future<Result<PatientModel>> completePatientRegistration({
    required String userId,
    required DateTime dateOfBirth,
    required String gender,
    required String bloodGroup,
    required List<String> allergies,
    required List<String> chronicConditions,
    required String emergencyContactName,
    required String emergencyContactPhone,
  }) async {
    try {
      // Validate inputs
      if (userId.isEmpty) {
        return Result.error('User ID cannot be empty');
      }

      if (emergencyContactName.isEmpty || emergencyContactPhone.isEmpty) {
        return Result.error('Emergency contact information is required');
      }

      // Register patient
      final result = await _repository.registerPatient(
        userId: userId,
        dateOfBirth: dateOfBirth.toString().split(
          ' ',
        )[0], // Format as YYYY-MM-DD
        gender: gender,
        bloodGroup: bloodGroup,
        allergies: allergies,
        chronicConditions: chronicConditions,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
      );

      return result.fold(
        (failure) => Result.error(failure.message),
        (patient) => Result.success(patient),
      );
    } catch (e) {
      return Result.error('Failed to complete registration: ${e.toString()}');
    }
  }

  /// Get patient profile (with caching consideration)
  Future<Result<PatientModel>> getPatientProfile(String userId) async {
    try {
      final result = await _repository.fetchPatientProfile(userId);
      return result.fold(
        (failure) => Result.error(failure.message),
        (patient) => Result.success(patient),
      );
    } catch (e) {
      return Result.error('Failed to fetch patient profile: ${e.toString()}');
    }
  }

  /// Update patient medical information
  Future<Result<PatientModel>> updateMedicalInfo({
    required String userId,
    required DateTime dateOfBirth,
    required String bloodGroup,
    required List<String> allergies,
    required List<String> chronicConditions,
  }) async {
    try {
      final result = await _repository.updatePatient(
        userId: userId,
        dateOfBirth: dateOfBirth.toString().split(' ')[0],
        bloodGroup: bloodGroup,
        allergies: allergies,
        chronicConditions: chronicConditions,
      );

      return result.fold(
        (failure) => Result.error(failure.message),
        (patient) => Result.success(patient),
      );
    } catch (e) {
      return Result.error('Failed to update medical info: ${e.toString()}');
    }
  }

  /// Update emergency contact information
  Future<Result<PatientModel>> updateEmergencyContact({
    required String userId,
    required String emergencyContactName,
    required String emergencyContactPhone,
  }) async {
    try {
      final result = await _repository.updatePatient(
        userId: userId,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
      );

      return result.fold(
        (failure) => Result.error(failure.message),
        (patient) => Result.success(patient),
      );
    } catch (e) {
      return Result.error(
        'Failed to update emergency contact: ${e.toString()}',
      );
    }
  }

  /// Check if patient has completed their profile
  Future<Result<bool>> hasCompletedProfile(String userId) async {
    try {
      final result = await _repository.patientExists(userId);
      return result.fold(
        (failure) => Result.error(failure.message),
        (exists) => Result.success(exists),
      );
    } catch (e) {
      return Result.error('Failed to check patient status: ${e.toString()}');
    }
  }
}

/// Generic Result class for success/error handling
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({required this.data, required this.error, required this.isSuccess});

  factory Result.success(T data) {
    return Result._(data: data, error: null, isSuccess: true);
  }

  factory Result.error(String error) {
    return Result._(data: null, error: error, isSuccess: false);
  }
}

/// Patient Service Provider for easy access throughout the app
final patientServiceProvider = Provider((ref) {
  final repository = ref.watch(patientRepositoryProvider);
  return PatientService(repository);
});
