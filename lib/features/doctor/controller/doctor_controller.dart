import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/doctor_repository.dart';

final doctorRepositoryProvider = Provider((ref) => DoctorRepository());
