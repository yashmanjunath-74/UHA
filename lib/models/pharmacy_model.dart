import 'enums.dart';

class PharmacyModel {
  final String id;
  final String userId;
  final String name;
  final String? address;
  final String? city;
  final String? licenseNumber;
  final String? gstNumber;
  final VerificationStatus verificationStatus;

  const PharmacyModel({
    required this.id,
    required this.userId,
    required this.name,
    this.address,
    this.city,
    this.licenseNumber,
    this.gstNumber,
    this.verificationStatus = VerificationStatus.pending,
  });

  factory PharmacyModel.fromMap(Map<String, dynamic> map) {
    // Handle the fact that DB might not have verification_status or uses different field names
    String vStatusStr = map['verification_status'] as String? ?? 'pending';
    VerificationStatus vStatus;
    try {
      vStatus = VerificationStatus.values.byName(vStatusStr);
    } catch (_) {
      vStatus = VerificationStatus.pending;
    }

    return PharmacyModel(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? map['pharmacy_name'] as String? ?? 'Unknown Pharmacy',
      address: map['address'] as String?,
      city: map['city'] as String?,
      licenseNumber: map['license_number'] as String?,
      gstNumber: map['gst_number'] as String?,
      verificationStatus: vStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'city': city,
      'license_number': licenseNumber,
      'gst_number': gstNumber,
      'verification_status': verificationStatus.name,
    };
  }
}
