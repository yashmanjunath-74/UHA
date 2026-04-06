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
      userId: map['user_id'] as String,
      name: map['name'] as String,
      address: map['address'] as String?,
      city: map['city'] as String?,
      registrationNumber: map['registration_number'] as String?,
      testTypes: List<String>.from(map['test_types'] ?? []),
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
