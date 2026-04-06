import 'enums.dart';

class DoctorModel {
  final String id;
  final String userId;
  final String? specialization;
  final String? registrationNumber;
  final int? experienceYears;
  final String? qualifications;
  final String? hospitalAffiliation;
  final VerificationStatus verificationStatus;
  final double consultationFee;

  const DoctorModel({
    required this.id,
    required this.userId,
    this.specialization,
    this.registrationNumber,
    this.experienceYears,
    this.qualifications,
    this.hospitalAffiliation,
    this.verificationStatus = VerificationStatus.pending,
    this.consultationFee = 0.0,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      specialization: map['specialization'] as String?,
      registrationNumber: map['registration_number'] as String?,
      experienceYears: map['experience_years'] as int?,
      qualifications: map['qualifications'] as String?,
      hospitalAffiliation: map['hospital_affiliation'] as String?,
      verificationStatus: VerificationStatus.values.byName(
        map['verification_status'] as String? ?? 'pending',
      ),
      consultationFee: (map['consultation_fee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'specialization': specialization,
      'registration_number': registrationNumber,
      'experience_years': experienceYears,
      'qualifications': qualifications,
      'hospital_affiliation': hospitalAffiliation,
      'verification_status': verificationStatus.name,
      'consultation_fee': consultationFee,
    };
  }
}
