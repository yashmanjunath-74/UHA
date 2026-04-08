
class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime scheduledAt;
  final String status; // pending, confirmed, completed, cancelled
  final double fee;
  final String? notes;
  final DateTime createdAt;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.scheduledAt,
    required this.status,
    required this.fee,
    this.notes,
    required this.createdAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      doctorId: map['doctor_id'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      status: map['status'] as String? ?? 'pending',
      fee: (map['fee'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
      'fee': fee,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? scheduledAt,
    String? status,
    double? fee,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      fee: fee ?? this.fee,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
