import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/medical_record_model.dart';

class MedicalRecordRepository {
  final SupabaseClient _supabaseClient;

  MedicalRecordRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Fetch medical records for a patient
  FutureEither<List<MedicalRecordModel>> fetchMedicalRecords(String patientId) async {
    try {
      final response = await _supabaseClient
          .from('medical_records')
          .select()
          .eq('patient_id', patientId)
          .order('record_date', ascending: false);

      final records = (response as List)
          .map((data) => MedicalRecordModel.fromMap(data as Map<String, dynamic>))
          .toList();

      return right(records);
    } catch (e) {
      return left(Failure('Failed to fetch medical records: ${e.toString()}'));
    }
  }

  /// Get patient health score (placeholder logic)
  FutureEither<int> fetchHealthScore(String patientId) async {
    try {
      return right(84);
    } catch (e) {
      return left(Failure('Failed to fetch health score: ${e.toString()}'));
    }
  }

  /// Add a new medical record
  FutureEither<MedicalRecordModel> addMedicalRecord(MedicalRecordModel record) async {
    try {
      final response = await _supabaseClient
          .from('medical_records')
          .insert({
            'patient_id': record.patientId,
            'doctor_id': record.doctorId,
            'doctor_name': record.doctorName,
            'type': record.type,
            'title': record.title,
            'description': record.description,
            'file_url': record.fileUrl,
            'record_date': record.recordDate.toIso8601String(),
            'tags': record.tags,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return right(MedicalRecordModel.fromMap(response));
    } catch (e) {
      return left(Failure('Failed to add medical record: ${e.toString()}'));
    }
  }
}
