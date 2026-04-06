import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PharmacyRepository {
  final _supabase = Supabase.instance.client;

  Future<String?> uploadDocument(String userId, File file) async {
    final ext = file.path.split('.').last;
    final path = 'pharmacy_documents/$userId/license.$ext';
    await _supabase.storage.from('pharmacy_documents').upload(path, file, fileOptions: const FileOptions(upsert: true));
    return _supabase.storage.from('pharmacy_documents').getPublicUrl(path);
  }

  Future<void> registerPharmacy({
    required String id,
    required String pharmacyName,
    required String pharmacyType,
    required String licenseNumber,
    required String contactNumber,
    required String officialEmail,
    required String address,
    required bool isHospitalAffiliated,
    String? affiliatedHospitalId,
    required bool hasDelivery,
    required bool has24hrService,
    required bool hasInsuranceBilling,
    String? documentUrl,
  }) async {
    await _supabase.from('pharmacies').upsert({
      'id': id,
      'pharmacy_name': pharmacyName,
      'pharmacy_type': pharmacyType,
      'license_number': licenseNumber,
      'contact_number': contactNumber,
      'official_email': officialEmail,
      'address': address,
      'is_hospital_affiliated': isHospitalAffiliated,
      'affiliated_hospital_id': affiliatedHospitalId,
      'has_delivery': hasDelivery,
      'has_24hr_service': has24hrService,
      'has_insurance_billing': hasInsuranceBilling,
      'document_url': documentUrl,
    });
  }

  Future<List<Map<String, dynamic>>> getApprovedHospitals() async {
    final response = await _supabase
        .from('hospitals')
        .select('id, institution_name, institution_type')
        .order('institution_name');
    return List<Map<String, dynamic>>.from(response);
  }
}

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((_) => PharmacyRepository());
