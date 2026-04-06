import 'enums.dart';

class HospitalModel {
  final String id;
  final String userId;
  final String name;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? registrationNumber;
  final int? bedCount;
  final List<String> departments;
  final VerificationStatus verificationStatus;

  const HospitalModel({
    required this.id,
    required this.userId,
    required this.name,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.registrationNumber,
    this.bedCount,
    this.departments = const [],
    this.verificationStatus = VerificationStatus.pending,
  });

  factory HospitalModel.fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      address: map['address'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      pincode: map['pincode'] as String?,
      registrationNumber: map['registration_number'] as String?,
      bedCount: map['bed_count'] as int?,
      departments: List<String>.from(map['departments'] ?? []),
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
      'state': state,
      'pincode': pincode,
      'registration_number': registrationNumber,
      'bed_count': bedCount,
      'departments': departments,
      'verification_status': verificationStatus.name,
    };
  }
}
