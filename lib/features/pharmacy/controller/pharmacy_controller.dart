import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/pharmacy_repository.dart';

final pharmacyRepositoryProvider = Provider((ref) => PharmacyRepository());
