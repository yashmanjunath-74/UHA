class HospitalAdmissionModel {
  final String id;
  final String hospitalId;
  final String? patientId;
  final String patientName;
  final String patientDisplayId;
  final int age;
  final String gender;
  final String ward;
  final String status;
  final String doctorName;
  final String bedNo;
  final String admittedSince;

  HospitalAdmissionModel({
    required this.id,
    required this.hospitalId,
    this.patientId,
    required this.patientName,
    required this.patientDisplayId,
    required this.age,
    required this.gender,
    required this.ward,
    required this.status,
    required this.doctorName,
    required this.bedNo,
    required this.admittedSince,
  });

  factory HospitalAdmissionModel.fromMap(Map<String, dynamic> map) {
    return HospitalAdmissionModel(
      id: map['id']?.toString() ?? '',
      hospitalId: map['hospital_id']?.toString() ?? '',
      patientId: map['patient_id']?.toString(),
      patientName: map['patient_name']?.toString() ?? '',
      patientDisplayId: map['patient_display_id']?.toString() ?? '',
      age: map['age'] as int? ?? 0,
      gender: map['gender']?.toString() ?? '',
      ward: map['ward']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      doctorName: map['doctor_name']?.toString() ?? '',
      bedNo: map['bed_no']?.toString() ?? '',
      admittedSince: map['admitted_since']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'hospital_id': hospitalId,
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_display_id': patientDisplayId,
      'age': age,
      'gender': gender,
      'ward': ward,
      'status': status,
      'doctor_name': doctorName,
      'bed_no': bedNo,
      'admitted_since': admittedSince,
    };
  }
}
