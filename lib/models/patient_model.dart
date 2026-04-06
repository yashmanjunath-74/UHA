import 'enums.dart';

class PatientModel {
  final String id;
  final String userId;
  final String? dateOfBirth;
  final Gender? gender;
  final String? bloodGroup;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  const PatientModel({
    required this.id,
    required this.userId,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      dateOfBirth: map['date_of_birth'] as String?,
      gender: map['gender'] != null
          ? Gender.values.firstWhere(
            (e) =>
                e.name.toLowerCase() == (map['gender'] as String).toLowerCase(),
            orElse: () => Gender.other,
          )
          : null,
      bloodGroup: map['blood_group'] as String?,
      allergies: List<String>.from(map['allergies'] ?? []),
      chronicConditions: List<String>.from(map['chronic_conditions'] ?? []),
      emergencyContactName: map['emergency_contact_name'] as String?,
      emergencyContactPhone: map['emergency_contact_phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date_of_birth': dateOfBirth,
      'gender': gender?.name,
      'blood_group': bloodGroup,
      'allergies': allergies,
      'chronic_conditions': chronicConditions,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
    };
  }
}
