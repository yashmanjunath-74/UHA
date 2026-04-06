import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/patient_model.dart';

class PatientRepository {
  final SupabaseClient _supabaseClient;

  PatientRepository({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  /// Register a new patient profile
  FutureEither<PatientModel> registerPatient({
    required String userId,
    required String dateOfBirth,
    required String gender,
    required String bloodGroup,
    required List<String> allergies,
    required List<String> chronicConditions,
    required String emergencyContactName,
    required String emergencyContactPhone,
  }) async {
    try {
      final response = await _supabaseClient.from('patients').insert({
        'user_id': userId,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'blood_group': bloodGroup,
        'allergies': allergies,
        'chronic_conditions': chronicConditions,
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).select();

      if (response.isEmpty) {
        return left(Failure('Failed to register patient: No data returned'));
      }

      final patientData = response.first;
      return right(PatientModel.fromMap(patientData));
    } catch (e) {
      return left(Failure('Failed to register patient: ${e.toString()}'));
    }
  }

  /// Fetch patient profile by user ID
  FutureEither<PatientModel> fetchPatientProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('patients')
          .select()
          .eq('user_id', userId)
          .single();

      return right(PatientModel.fromMap(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return left(Failure('Patient profile not found'));
      }
      return left(Failure('Failed to fetch patient profile: ${e.message}'));
    } catch (e) {
      return left(Failure('Failed to fetch patient profile: ${e.toString()}'));
    }
  }

  /// Update patient profile
  FutureEither<PatientModel> updatePatient({
    required String userId,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    List<String>? allergies,
    List<String>? chronicConditions,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth;
      if (gender != null) updateData['gender'] = gender;
      if (bloodGroup != null) updateData['blood_group'] = bloodGroup;
      if (allergies != null) updateData['allergies'] = allergies;
      if (chronicConditions != null)
        updateData['chronic_conditions'] = chronicConditions;
      if (emergencyContactName != null)
        updateData['emergency_contact_name'] = emergencyContactName;
      if (emergencyContactPhone != null)
        updateData['emergency_contact_phone'] = emergencyContactPhone;

      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabaseClient
          .from('patients')
          .update(updateData)
          .eq('user_id', userId)
          .select();

      if (response.isEmpty) {
        return left(Failure('Failed to update patient profile: Profile not found'));
      }

      final patientData = response.first;
      return right(PatientModel.fromMap(patientData));
    } catch (e) {
      return left(Failure('Failed to update patient profile: ${e.toString()}'));
    }
  }

  /// Check if patient profile exists
  FutureEither<bool> patientExists(String userId) async {
    try {
      final response = await _supabaseClient
          .from('patients')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      return right(response != null);
    } catch (e) {
      return left(
        Failure('Failed to check patient existence: ${e.toString()}'),
      );
    }
  }

  /// Delete patient profile (for testing purposes only)
  FutureEither<void> deletePatient(String userId) async {
    try {
      await _supabaseClient.from('patients').delete().eq('user_id', userId);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to delete patient profile: ${e.toString()}'));
    }
  }
}
