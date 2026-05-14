import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/pharmacy_controller.dart';

// Models
class PharmacyOrder {
  final String id;
  final String patientName;
  final String patientId;
  final int age;
  final String gender;
  final String time;
  final String status; // 'New', 'Preparing', 'Ready', 'Completed'
  final List<MedicineItem> items;
  final bool isUrgent;
  final String doctorName;

  PharmacyOrder({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.time,
    required this.status,
    required this.items,
    this.isUrgent = false,
    required this.doctorName,
  });
}

class MedicineItem {
  final String name;
  final String dosage;
  final String quantity;
  final String instructions;

  MedicineItem({
    required this.name,
    required this.dosage,
    required this.quantity,
    required this.instructions,
  });
}

// Local UI State for Filter
class PharmacyFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All Orders';
}

final pharmacyFilterProvider = NotifierProvider<PharmacyFilterNotifier, String>(PharmacyFilterNotifier.new);

