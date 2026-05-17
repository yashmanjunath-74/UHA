import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';

class HospitalRepository {
  final SupabaseClient supabaseClient;

  HospitalRepository({required this.supabaseClient});

  FutureEither<List<Map<String, dynamic>>> fetchStaff(String hospitalId) async {
    try {
      final res = await supabaseClient
          .from('hospital_staff')
          .select()
          .eq('hospital_id', hospitalId)
          .order('name');
      return right(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<Map<String, dynamic>>> fetchAdmissions(String hospitalId) async {
    try {
      final res = await supabaseClient
          .from('hospital_admissions')
          .select()
          .eq('hospital_id', hospitalId)
          .order('patient_name');
      return right(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> addStaff(Map<String, dynamic> staffData) async {
    try {
      await supabaseClient.from('hospital_staff').insert(staffData);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> addAdmission(Map<String, dynamic> admissionData) async {
    try {
      await supabaseClient.from('hospital_admissions').insert(admissionData);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateAdmissionStatus(String admissionId, String status) async {
    try {
      await supabaseClient
          .from('hospital_admissions')
          .update({'status': status})
          .eq('id', admissionId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<String?> uploadDocument(String userId, File file) async {
    try {
      final fileName = 'hospital_docs/$userId/registration_license.pdf';
      await supabaseClient.storage.from('hospital_documents').upload(fileName, file);
      return supabaseClient.storage.from('hospital_documents').getPublicUrl(fileName);
    } catch (e) {
      print('Document upload failed: $e');
      return null;
    }
  }

  Future<void> registerHospital({
    required String id,
    required String institutionName,
    required String institutionType,
    required String contactNumber,
    required String officialEmail,
    required int bedCapacity,
    required int departments,
    required bool hasEmergency,
    required bool hasAmbulance,
    required bool hasICU,
    String? documentUrl,
  }) async {
    await supabaseClient.from('hospitals').insert({
      'id': id,
      'user_id': id,
      'name': institutionName,
      'institution_type': institutionType,
      'contact_number': contactNumber,
      'official_email': officialEmail,
      'bed_count': bedCapacity,
      'department_count': departments,
      'has_emergency': hasEmergency,
      'has_ambulance': hasAmbulance,
      'has_icu': hasICU,
      'document_url': documentUrl,
      'verification_status': 'pending',
    });
  }
}
