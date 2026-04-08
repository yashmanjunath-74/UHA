class MedicalRecordModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String? doctorName;
  final String type; // lab_report, prescription, vaccination, etc.
  final String title;
  final String? description;
  final String? fileUrl;
  final DateTime recordDate;
  final List<String> tags;
  final DateTime createdAt;

  const MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.doctorName,
    required this.type,
    required this.title,
    this.description,
    this.fileUrl,
    required this.recordDate,
    this.tags = const [],
    required this.createdAt,
  });

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map) {
    return MedicalRecordModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      doctorId: map['doctor_id'] as String,
      doctorName: map['doctor_name'] as String?,
      type: map['type'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      fileUrl: map['file_url'] as String?,
      recordDate: DateTime.parse(map['record_date'] as String),
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'type': type,
      'title': title,
      'description': description,
      'file_url': fileUrl,
      'record_date': recordDate.toIso8601String(),
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
