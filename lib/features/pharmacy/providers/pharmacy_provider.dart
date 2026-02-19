import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PharmacyState {
  final List<PharmacyOrder> orders;
  final String selectedFilter;

  PharmacyState({required this.orders, this.selectedFilter = 'All Orders'});

  PharmacyState copyWith({
    List<PharmacyOrder>? orders,
    String? selectedFilter,
  }) {
    return PharmacyState(
      orders: orders ?? this.orders,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

// Provider
final pharmacyProvider = NotifierProvider<PharmacyNotifier, PharmacyState>(
  PharmacyNotifier.new,
);

class PharmacyNotifier extends Notifier<PharmacyState> {
  @override
  PharmacyState build() {
    return PharmacyState(
      orders: [
        PharmacyOrder(
          id: 'ORD-9281',
          patientName: 'Sarah Jenkins',
          patientId: 'P-9982',
          age: 45,
          gender: 'Female',
          time: '10:42 AM',
          status: 'New',
          isUrgent: true,
          doctorName: 'Dr. Emily Chen',
          items: [
            MedicineItem(
              name: 'Amoxicillin',
              dosage: '500mg',
              quantity: '30',
              instructions:
                  'Take 1 tablet every 8 hours for 10 days after food.',
            ),
          ],
        ),
        PharmacyOrder(
          id: 'ORD-9278',
          patientName: 'Michael Chen',
          patientId: 'P-8821',
          age: 32,
          gender: 'Male',
          time: '09:15 AM',
          status: 'Preparing',
          doctorName: 'Dr. Alan Smith',
          items: [
            MedicineItem(
              name: 'Lisinopril',
              dosage: '10mg',
              quantity: '90',
              instructions: 'Take 1 tablet daily in the morning.',
            ),
            MedicineItem(
              name: 'Aspirin',
              dosage: '81mg',
              quantity: '100',
              instructions: 'Take 1 tablet daily with food.',
            ),
          ],
        ),
        PharmacyOrder(
          id: 'ORD-9265',
          patientName: 'Emma Wilson',
          patientId: 'P-7734',
          age: 28,
          gender: 'Female',
          time: '08:30 AM',
          status: 'Ready',
          doctorName: 'Dr. Sarah Johnson',
          items: [
            MedicineItem(
              name: 'Ventolin HFA Inhaler',
              dosage: '90mcg',
              quantity: '1',
              instructions: 'Use 2 puffs every 4-6 hours as needed.',
            ),
          ],
        ),
        PharmacyOrder(
          id: 'ORD-9250',
          patientName: 'Robert Fox',
          patientId: 'P-6612',
          age: 55,
          gender: 'Male',
          time: 'Yesterday',
          status: 'New',
          doctorName: 'Dr. James Wilson',
          items: [
            MedicineItem(
              name: 'Metformin',
              dosage: '500mg',
              quantity: '60',
              instructions: 'Take 1 tablet twice daily with meals.',
            ),
          ],
        ),
      ],
    );
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return PharmacyOrder(
          id: order.id,
          patientName: order.patientName,
          patientId: order.patientId,
          age: order.age,
          gender: order.gender,
          time: order.time,
          status: newStatus,
          items: order.items,
          isUrgent: order.isUrgent,
          doctorName: order.doctorName,
        );
      }
      return order;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }
}
