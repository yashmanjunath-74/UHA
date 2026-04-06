import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';
import 'doctor_repository.dart';

class DoctorRegState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final String fullName, specialty, licenseNumber, qualification;
  final int yearsOfExp;
  final File? document;
  final bool isIndependent;
  final List<String> selectedHospitalIds;
  final List<Map<String, dynamic>> hospitals;
  final String clinicAddress, workPhone;
  final String adminEmail, password, confirmPassword;

  const DoctorRegState({
    this.isLoading = false, this.error, this.isSuccess = false,
    this.fullName = '', this.specialty = '', this.licenseNumber = '', this.qualification = '',
    this.yearsOfExp = 5, this.document,
    this.isIndependent = false, this.selectedHospitalIds = const [],
    this.hospitals = const [], this.clinicAddress = '', this.workPhone = '',
    this.adminEmail = '', this.password = '', this.confirmPassword = '',
  });

  DoctorRegState copyWith({bool? isLoading, String? error, bool? isSuccess, String? fullName, String? specialty, String? licenseNumber, String? qualification, int? yearsOfExp, File? document, bool? isIndependent, List<String>? selectedHospitalIds, List<Map<String, dynamic>>? hospitals, String? clinicAddress, String? workPhone, String? adminEmail, String? password, String? confirmPassword}) => DoctorRegState(isLoading: isLoading ?? this.isLoading, error: error, isSuccess: isSuccess ?? this.isSuccess, fullName: fullName ?? this.fullName, specialty: specialty ?? this.specialty, licenseNumber: licenseNumber ?? this.licenseNumber, qualification: qualification ?? this.qualification, yearsOfExp: yearsOfExp ?? this.yearsOfExp, document: document ?? this.document, isIndependent: isIndependent ?? this.isIndependent, selectedHospitalIds: selectedHospitalIds ?? this.selectedHospitalIds, hospitals: hospitals ?? this.hospitals, clinicAddress: clinicAddress ?? this.clinicAddress, workPhone: workPhone ?? this.workPhone, adminEmail: adminEmail ?? this.adminEmail, password: password ?? this.password, confirmPassword: confirmPassword ?? this.confirmPassword);
}

class DoctorRegNotifier extends Notifier<DoctorRegState> {
  late final AuthRepository _auth;
  late final DoctorRepository _repo;

  @override
  DoctorRegState build() {
    _auth = ref.read(authRepositoryProvider);
    _repo = ref.read(doctorRepositoryProvider);
    return const DoctorRegState();
  }

  void setDocument(File f) => state = state.copyWith(document: f);
  void setStep1(String fullName, String specialty, String licenseNumber, String qualification, int yearsOfExp) =>
      state = state.copyWith(fullName: fullName, specialty: specialty, licenseNumber: licenseNumber, qualification: qualification, yearsOfExp: yearsOfExp);
  void setIndependent(bool v) => state = state.copyWith(isIndependent: v);
  void setStep2(String phone, String address) => state = state.copyWith(workPhone: phone, clinicAddress: address);
  void setAccount(String email, String pass, String confirm) => state = state.copyWith(adminEmail: email, password: pass, confirmPassword: confirm);

  Future<void> loadHospitals() async {
    try { state = state.copyWith(hospitals: await _repo.getApprovedHospitals()); } catch (_) {}
  }

  void toggleHospital(String id) {
    final current = List<String>.from(state.selectedHospitalIds);
    if (current.contains(id)) { current.remove(id); } else { current.add(id); }
    state = state.copyWith(selectedHospitalIds: current);
  }

  Future<void> submit() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (state.adminEmail.isEmpty || state.password.isEmpty) throw Exception('Email and password are required.');
      if (state.password != state.confirmPassword) throw Exception('Passwords do not match.');
      final res = await _auth.signUp(email: state.adminEmail, password: state.password);
      if (res.user == null) throw Exception('Registration failed.');
      final uid = res.user!.id;
      await _auth.updateProfile(uid: uid, firstName: state.fullName, lastName: '', role: 'doctor');
      await _auth.updateUserApproval(uid, false);
      String? docUrl;
      if (state.document != null) docUrl = await _repo.uploadDocument(uid, state.document!);
      await _repo.registerDoctor(id: uid, fullName: state.fullName, specialty: state.specialty, licenseNumber: state.licenseNumber, qualification: state.qualification, yearsOfExperience: state.yearsOfExp, workPhone: state.workPhone, clinicAddress: state.clinicAddress.isEmpty ? null : state.clinicAddress, documentUrl: docUrl, isIndependent: state.isIndependent);
      if (!state.isIndependent && state.selectedHospitalIds.isNotEmpty) await _repo.addHospitalAffiliations(uid, state.selectedHospitalIds);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) { state = state.copyWith(isLoading: false, error: e.toString()); }
  }
}

final doctorRegProvider = NotifierProvider<DoctorRegNotifier, DoctorRegState>(DoctorRegNotifier.new);
