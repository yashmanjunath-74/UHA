import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class HospitalRepository {
  final SupabaseClient _supabase;

  HospitalRepository(this._supabase);

  // Upload document
  Future<String> uploadDocument(String hospitalId, File file) async {
    final fileExt = file.path.split('.').last;
    final fileName = '$hospitalId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = '$hospitalId/$fileName';

    await _supabase.storage.from('hospital_documents').upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    final publicUrl = _supabase.storage.from('hospital_documents').getPublicUrl(filePath);
    return publicUrl;
  }

  // Register Hospital
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
    await _supabase.from('hospitals').insert({
      'id': id,
      'institution_name': institutionName,
      'institution_type': institutionType,
      'contact_number': contactNumber,
      'official_email': officialEmail,
      'bed_capacity': bedCapacity,
      'departments': departments,
      'has_emergency': hasEmergency,
      'has_ambulance': hasAmbulance,
      'has_icu': hasICU,
      'document_url': documentUrl,
    });
  }

  // Get Hospital details for admin
  Future<Map<String, dynamic>?> getHospitalDetails(String id) async {
    final res = await _supabase.from('hospitals').select().eq('id', id).maybeSingle();
    return res;
  }
}

final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  return HospitalRepository(Supabase.instance.client);
});
