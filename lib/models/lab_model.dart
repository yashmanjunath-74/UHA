import 'enums.dart';

class LabModel {
  final String id;
  final String userId;
  final String name;
  final String? address;
  final String? city;
  final String? registrationNumber;
  final List<String> testTypes;
  final VerificationStatus verificationStatus;

  const LabModel({
    required this.id,
    required this.userId,
    required this.name,
    this.address,
    this.city,
    this.registrationNumber,
    this.testTypes = const [],
    this.verificationStatus = VerificationStatus.pending,
  });

  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id'] as String,
      userId: map['user_id'] as String? ?? map['id'] as String, // Fallback to id if user_id is null
      name: (map['lab_name'] ?? map['name'] ?? 'Unknown Lab') as String,
      address: map['address'] as String?,
      city: map['city'] as String?,
      registrationNumber: (map['license_number'] ?? map['registration_number']) as String?,
      testTypes: (map['test_types'] != null && (map['test_types'] as List).isNotEmpty)
          ? List<String>.from(map['test_types'])
          : ['Blood Test', 'X-Ray', 'Urine Test', 'MRI'],
      verificationStatus: VerificationStatus.values.byName(
        map['verification_status'] as String? ?? 'pending',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'city': city,
      'registration_number': registrationNumber,
      'test_types': testTypes,
      'verification_status': verificationStatus.name,
    };
  }
}
