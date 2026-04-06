import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload a document to Supabase Storage
  Future<String?> uploadDocument(String userId, File file) async {
    final ext = file.path.split('.').last;
    final path = 'doctor_documents/$userId/license.$ext';
    await _supabase.storage.from('doctor_documents').upload(path, file, fileOptions: const FileOptions(upsert: true));
    return _supabase.storage.from('doctor_documents').getPublicUrl(path);
  }

  /// Insert the doctor's profile record
  Future<void> registerDoctor({
    required String id,
    required String fullName,
    required String specialty,
    required String licenseNumber,
    required String qualification,
    required int yearsOfExperience,
    required String workPhone,
    String? clinicAddress,
    String? documentUrl,
    bool isIndependent = false,
  }) async {
    await _supabase.from('doctors').upsert({
      'id': id,
      'full_name': fullName,
      'specialty': specialty,
      'license_number': licenseNumber,
      'qualification': qualification,
      'years_of_experience': yearsOfExperience,
      'work_phone': workPhone,
      'clinic_address': clinicAddress,
      'document_url': documentUrl,
      'is_independent': isIndependent,
    });
  }

  /// Insert doctor-hospital affiliations (one per selected hospital)
  Future<void> addHospitalAffiliations(String doctorId, List<String> hospitalIds) async {
    if (hospitalIds.isEmpty) return;
    final rows = hospitalIds.map((hId) => {
      'doctor_id': doctorId,
      'hospital_id': hId,
      'status': 'pending',
    }).toList();
    await _supabase.from('doctor_hospital_affiliations').upsert(rows);
  }

  /// Fetch list of approved hospitals for the multi-select picker
  Future<List<Map<String, dynamic>>> getApprovedHospitals() async {
    final response = await _supabase
        .from('hospitals')
        .select('id, institution_name, institution_type')
        .order('institution_name');
    return List<Map<String, dynamic>>.from(response);
  }
}

final doctorRepositoryProvider = Provider<DoctorRepository>((_) => DoctorRepository());
