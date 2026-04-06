import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/lab_repository.dart';

final labRepositoryProvider = Provider((ref) => LabRepository());
