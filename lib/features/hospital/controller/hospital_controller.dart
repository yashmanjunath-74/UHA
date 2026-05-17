import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/hospital_staff_model.dart';
import '../../../models/hospital_admission_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/hospital_repository.dart';

final hospitalRepositoryProvider = Provider(
  (ref) => HospitalRepository(supabaseClient: Supabase.instance.client),
);

// Fallback Mock Data for Staff
final List<Map<String, dynamic>> _mockStaff = [
  {
    'name': 'Dr. Sarah Jenkins',
    'role': 'Chief Surgeon',
    'department': 'Cardiology',
    'status': 'Active',
    'phone': '+1 234 567 890',
    'email': 'sarah.j@stmarys.com',
    'is_doctor': true,
  },
  {
    'name': 'Dr. Robert Chen',
    'role': 'Senior Physician',
    'department': 'Neurology',
    'status': 'Active',
    'phone': '+1 234 567 891',
    'email': 'robert.c@stmarys.com',
    'is_doctor': true,
  },
  {
    'name': 'Emily Davis',
    'role': 'Head Nurse',
    'department': 'ICU',
    'status': 'Active',
    'phone': '+1 234 567 892',
    'email': 'emily.d@stmarys.com',
    'is_doctor': false,
  },
  {
    'name': 'Dr. Michael Roberts',
    'role': 'Orthopedic Surgeon',
    'department': 'Orthopedics',
    'status': 'On Leave',
    'phone': '+1 234 567 893',
    'email': 'michael.r@stmarys.com',
    'is_doctor': true,
  },
  {
    'name': 'Jessica Taylor',
    'role': 'Emergency Nurse',
    'department': 'Emergency',
    'status': 'Off Duty',
    'phone': '+1 234 567 894',
    'email': 'jessica.t@stmarys.com',
    'is_doctor': false,
  },
];

// Fallback Mock Data for Admissions
final List<Map<String, dynamic>> _mockAdmissions = [
  {
    'patient_name': 'Rajesh Kumar',
    'patient_display_id': 'UHA-20241',
    'age': 45,
    'ward': 'Cardiology',
    'status': 'Admitted',
    'doctor_name': 'Dr. Sharma',
    'bed_no': 'A-12',
    'admitted_since': '2 days',
    'gender': 'M',
  },
  {
    'patient_name': 'Priya Patel',
    'patient_display_id': 'UHA-20242',
    'age': 32,
    'ward': 'Maternity',
    'status': 'Admitted',
    'doctor_name': 'Dr. Mehta',
    'bed_no': 'B-05',
    'admitted_since': '1 day',
    'gender': 'F',
  },
  {
    'patient_name': 'Suresh Nair',
    'patient_display_id': 'UHA-20243',
    'age': 67,
    'ward': 'ICU',
    'status': 'Emergency',
    'doctor_name': 'Dr. Singh',
    'bed_no': 'ICU-03',
    'admitted_since': '5 hrs',
    'gender': 'M',
  },
  {
    'patient_name': 'Anita Reddy',
    'patient_display_id': 'UHA-20244',
    'age': 28,
    'ward': 'Orthopedics',
    'status': 'OPD',
    'doctor_name': 'Dr. Joseph',
    'bed_no': 'OPD-7',
    'admitted_since': 'Today',
    'gender': 'F',
  },
  {
    'patient_name': 'Vikas Gupta',
    'patient_display_id': 'UHA-20245',
    'age': 55,
    'ward': 'Neurology',
    'status': 'Discharged',
    'doctor_name': 'Dr. Rao',
    'bed_no': '-',
    'admitted_since': 'Yesterday',
    'gender': 'M',
  },
];

final hospitalStaffProvider = FutureProvider<List<HospitalStaffModel>>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return [];

  final res = await ref.read(hospitalRepositoryProvider).fetchStaff(user.id);
  return res.fold(
    (l) {
      // Return mutable copy of mock data
      return _mockStaff.map((map) {
        map['hospital_id'] = user.id;
        return HospitalStaffModel.fromMap(map);
      }).toList();
    },
    (r) {
      if (r.isNotEmpty) {
        return r.map((e) => HospitalStaffModel.fromMap(e)).toList();
      }
      return _mockStaff.map((map) {
        map['hospital_id'] = user.id;
        return HospitalStaffModel.fromMap(map);
      }).toList();
    },
  );
});

final hospitalAdmissionsProvider = FutureProvider<List<HospitalAdmissionModel>>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return [];

  final res = await ref.read(hospitalRepositoryProvider).fetchAdmissions(user.id);
  return res.fold(
    (l) {
      return _mockAdmissions.map((map) {
        map['hospital_id'] = user.id;
        return HospitalAdmissionModel.fromMap(map);
      }).toList();
    },
    (r) {
      if (r.isNotEmpty) {
        return r.map((e) => HospitalAdmissionModel.fromMap(e)).toList();
      }
      return _mockAdmissions.map((map) {
        map['hospital_id'] = user.id;
        return HospitalAdmissionModel.fromMap(map);
      }).toList();
    },
  );
});

class HospitalController {
  final Ref ref;
  HospitalController(this.ref);

  Future<void> addStaff(Map<String, dynamic> staffData) async {
    final user = ref.read(authProvider).session?.user;
    if (user == null) throw 'Not logged in';

    staffData['hospital_id'] = user.id;
    final res = await ref.read(hospitalRepositoryProvider).addStaff(staffData);
    
    res.fold(
      (l) {
        print('Warning DB add failed: ${l.message}');
        _mockStaff.add(staffData);
        ref.invalidate(hospitalStaffProvider);
      },
      (r) => ref.invalidate(hospitalStaffProvider),
    );
  }

  Future<void> addAdmission(Map<String, dynamic> admissionData) async {
    final user = ref.read(authProvider).session?.user;
    if (user == null) throw 'Not logged in';

    admissionData['hospital_id'] = user.id;
    final res = await ref.read(hospitalRepositoryProvider).addAdmission(admissionData);
    
    res.fold(
      (l) {
        print('Warning DB add failed: ${l.message}');
        _mockAdmissions.add(admissionData);
        ref.invalidate(hospitalAdmissionsProvider);
      },
      (r) => ref.invalidate(hospitalAdmissionsProvider),
    );
  }

  Future<void> updateAdmissionStatus(String admissionId, String status) async {
    final res = await ref.read(hospitalRepositoryProvider).updateAdmissionStatus(admissionId, status);
    
    res.fold(
      (l) {
        // Fallback for mock updates
        final index = _mockAdmissions.indexWhere((element) => element['id'] == admissionId || element['patient_display_id'] == admissionId);
        if (index != -1) {
          _mockAdmissions[index]['status'] = status;
        }
        ref.invalidate(hospitalAdmissionsProvider);
      },
      (r) => ref.invalidate(hospitalAdmissionsProvider),
    );
  }
}

final hospitalControllerProvider = Provider((ref) => HospitalController(ref));
