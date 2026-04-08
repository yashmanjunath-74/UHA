import '../../../models/doctor_model.dart';
import '../../../models/appointment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/doctor_repository.dart';

final doctorAppointmentsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return [];

  final doctorRepo = ref.read(doctorRepositoryProvider);
  // We need the doctor.id from the doctors table, not just the user.id
  final doctorProfileRes = await doctorRepo.fetchDoctorProfile(user.id);
  
  return doctorProfileRes.fold(
    (l) => throw Exception(l.message),
    (doctor) async {
      final res = await doctorRepo.fetchDoctorAppointments(doctor.id);
      return res.fold((l) => throw Exception(l.message), (r) => r);
    },
  );
});

final doctorProfileProvider = FutureProvider<DoctorModel?>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return null;

  final doctorRepo = ref.read(doctorRepositoryProvider);
  final res = await doctorRepo.fetchDoctorProfile(user.id);
  return res.fold((l) => throw Exception(l.message), (r) => r);
});

final doctorPatientsProvider = FutureProvider<List<String>>((ref) async {
  final appointments = await ref.watch(doctorAppointmentsProvider.future);
  return appointments.map((a) => a.patientId).toSet().toList();
});

final patientDoctorSearchProvider = FutureProvider.family<List<DoctorModel>, ({String? specialty, String? query})>((ref, args) async {
  final doctorRepo = ref.read(doctorRepositoryProvider);
  final res = await doctorRepo.searchDoctors(specialty: args.specialty, query: args.query);
  return res.fold((l) => throw Exception(l.message), (r) => r);
});

final topDoctorsProvider = FutureProvider<List<DoctorModel>>((ref) async {
  final doctorRepo = ref.read(doctorRepositoryProvider);
  final res = await doctorRepo.getTopDoctors();
  return res.fold((l) => throw Exception(l.message), (r) => r);
});

class DoctorController extends Notifier<bool> {
  late final DoctorRepository _doctorRepository;

  @override
  bool build() {
    _doctorRepository = ref.watch(doctorRepositoryProvider);
    return false;
  }

  Future<void> updateStatus(String status) async {
    state = true;
    final doctor = await ref.read(doctorProfileProvider.future);
    if (doctor != null) {
      await _doctorRepository.updateDoctorStatus(doctor.id, status);
    }
    state = false;
  }

  Future<void> updateAppointmentStatus(
      String appointmentId, String status, void Function(String)? onError, void Function()? onSuccess) async {
    state = true;
    final res = await _doctorRepository.updateAppointmentStatus(appointmentId, status);
    res.fold(
      (l) {
        if (onError != null) onError(l.message);
      },
      (r) {
        ref.invalidate(doctorAppointmentsProvider);
        if (onSuccess != null) onSuccess();
      },
    );
    state = false;
  }
}

final doctorControllerProvider = NotifierProvider<DoctorController, bool>(
  DoctorController.new,
);
