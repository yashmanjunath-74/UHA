import 'enums.dart';

class DoctorModel {
  final String id;
  final String userId;
  final String fullName;
  final String specialty;
  final String licenseNumber;
  final int yearsOfExperience;
  final String qualification;
  final String? clinicAddress;
  final String workPhone;
  final String? documentUrl;
  final bool isIndependent;
  final VerificationStatus verificationStatus;
  final double consultationFee;
  final String? avatarUrl;

  const DoctorModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.specialty,
    required this.licenseNumber,
    required this.yearsOfExperience,
    required this.qualification,
    this.clinicAddress,
    required this.workPhone,
    this.documentUrl,
    this.isIndependent = false,
    this.verificationStatus = VerificationStatus.pending,
    this.consultationFee = 500.0,
    this.avatarUrl,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as String,
      userId: map['user_id'] as String? ?? map['id'] as String,
      fullName: map['full_name'] as String? ?? 'Dr. Unknown',
      specialty: map['specialty'] as String? ?? 'General Physician',
      licenseNumber: map['license_number'] as String? ?? '',
      yearsOfExperience: map['years_of_experience'] as int? ?? 0,
      qualification: map['qualification'] as String? ?? '',
      clinicAddress: map['clinic_address'] as String?,
      workPhone: map['work_phone'] as String? ?? '',
      documentUrl: map['document_url'] as String?,
      isIndependent: map['is_independent'] as bool? ?? false,
      verificationStatus: VerificationStatus.values.byName(
        map['verification_status'] as String? ?? 'pending',
      ),
      consultationFee: (map['consultation_fee'] as num?)?.toDouble() ?? 500.0,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'specialty': specialty,
      'license_number': licenseNumber,
      'years_of_experience': yearsOfExperience,
      'qualification': qualification,
      'clinic_address': clinicAddress,
      'work_phone': workPhone,
      'document_url': documentUrl,
      'is_independent': isIndependent,
      'verification_status': verificationStatus.name,
      'consultation_fee': consultationFee,
      'avatar_url': avatarUrl,
    };
  }
}
