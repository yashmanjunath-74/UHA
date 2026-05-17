import 'package:flutter/foundation.dart';

class LabOrderModel {
  final String id;
  final String labId;
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String testName;
  final String status;
  final String time;
  final String? resultUrl;
  final String? doctorName;

  LabOrderModel({
    required this.id,
    required this.labId,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.testName,
    required this.status,
    required this.time,
    this.resultUrl,
    this.doctorName,
  });

  factory LabOrderModel.fromMap(Map<String, dynamic> map) {
    return LabOrderModel(
      id: map['id']?.toString() ?? '',
      labId: map['lab_id']?.toString() ?? '',
      patientId: map['patient_id']?.toString() ?? '',
      patientName: map['patient_name']?.toString() ?? 'Unknown Patient',
      patientAge: map['patient_age'] as int? ?? 0,
      patientGender: map['patient_gender']?.toString() ?? 'Unknown',
      testName: map['test_name']?.toString() ?? 'Unknown Test',
      status: map['status']?.toString() ?? 'Pending',
      time: map['created_at'] != null 
          ? DateTime.parse(map['created_at'].toString()).toLocal().toString() 
          : DateTime.now().toString(),
      resultUrl: map['result_url']?.toString(),
      doctorName: map['doctor_name']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'lab_id': labId,
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_age': patientAge,
      'patient_gender': patientGender,
      'test_name': testName,
      'status': status,
      'result_url': resultUrl,
      'doctor_name': doctorName,
    };
  }
}
