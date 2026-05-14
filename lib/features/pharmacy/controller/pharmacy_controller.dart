import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/pharmacy_repository.dart';
import '../../../models/pharmacy_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../providers/pharmacy_provider.dart';

final pharmacyRepositoryProvider = Provider((ref) => PharmacyRepository(
  supabaseClient: Supabase.instance.client,
));

final pharmacyProfileProvider = FutureProvider<PharmacyModel?>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return null;
  
  final res = await ref.read(pharmacyRepositoryProvider).fetchPharmacyProfile(user.id);
  return res.fold(
    (l) {
      // Fallback Profile if not set up in DB
      return PharmacyModel(
        id: 'mock-pharmacy-123',
        userId: user.id,
        name: 'Universal Health Pharmacy',
        licenseNumber: 'DL-KA-2023-0042',
        gstNumber: '29AAACM1234F1ZX',
        address: '12 MG Road',
        city: 'Bangalore',
      );
    },
    (r) => r,
  );
});

// Persistent mock state for demo purposes if DB is missing
final List<Map<String, dynamic>> _mockInventory = [
  {'name': 'Amoxicillin', 'category': 'Antibiotics', 'stock': 120, 'price': '45.00', 'color': const Color(0xFF10B981)},
  {'name': 'Paracetamol 650', 'category': 'Analgesics', 'stock': 450, 'price': '12.00', 'color': const Color(0xFF6366F1)},
  {'name': 'Metformin 500', 'category': 'Antidiabetic', 'stock': 85, 'price': '30.00', 'color': const Color(0xFFF59E0B)},
  {'name': 'Atorvastatin 20', 'category': 'Statins', 'stock': 60, 'price': '55.00', 'color': const Color(0xFF8B5CF6)},
];

final pharmacyInventoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final profile = await ref.watch(pharmacyProfileProvider.future);
  if (profile == null) return [];
  
  final res = await ref.read(pharmacyRepositoryProvider).fetchInventory(profile.id);
  return res.fold(
    (l) => List.from(_mockInventory), // Return mutable copy of mock data
    (r) => r.isNotEmpty ? r : List.from(_mockInventory),
  );
});

class PharmacyController {
  final Ref ref;
  PharmacyController(this.ref);

  Future<String?> addInventoryItem(Map<String, dynamic> item) async {
    final profile = await ref.read(pharmacyProfileProvider.future);
    if (profile == null) throw 'Pharmacy profile not found';
    
    item['pharmacy_id'] = profile.id;
    final res = await ref.read(pharmacyRepositoryProvider).addInventoryItem(item);
    
    String? dbError;
    res.fold(
      (l) {
        dbError = l.message;
        print('Warning: Failed to add to DB: ${l.message}');
        // Push to local mock list so UI updates for demo
        item['color'] = const Color(0xFF10B981); // Default color for newly added items
        _mockInventory.insert(0, item); // Add to top of the list
      },
      (r) {},
    );
    ref.invalidate(pharmacyInventoryProvider);
    return dbError;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final res = await ref.read(pharmacyRepositoryProvider).updateOrderStatus(orderId, status);
    res.fold(
      (l) => print('Warning: Failed to update DB: ${l.message}'), // Swallow error for demo
      (r) {},
    );
    ref.invalidate(pharmacyOrdersProvider);
  }
  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    final res = await ref.read(pharmacyRepositoryProvider).placeOrder(orderData);
    res.fold(
      (l) => throw l.message,
      (r) {},
    );
  }
}

final pharmacyControllerProvider = Provider((ref) => PharmacyController(ref));

// Provider for patients to view all pharmacies
final allPharmaciesProvider = FutureProvider<List<PharmacyModel>>((ref) async {
  final res = await ref.read(pharmacyRepositoryProvider).fetchAllPharmacies();
  return res.fold(
    (l) {
      // Fallback if DB not configured yet
      return [
        PharmacyModel(id: 'mock-1', userId: '', name: 'Universal Health Pharmacy', address: '12 MG Road', city: 'Bangalore'),
        PharmacyModel(id: 'mock-2', userId: '', name: 'Apollo Pharmacy', address: '45 Residency Rd', city: 'Bangalore'),
        PharmacyModel(id: 'mock-3', userId: '', name: 'MedPlus', address: 'Indiranagar 100ft Rd', city: 'Bangalore'),
      ];
    },
    (r) => r.isNotEmpty ? r : [
        PharmacyModel(id: 'mock-1', userId: '', name: 'Universal Health Pharmacy', address: '12 MG Road', city: 'Bangalore'),
        PharmacyModel(id: 'mock-2', userId: '', name: 'Apollo Pharmacy', address: '45 Residency Rd', city: 'Bangalore'),
    ],
  );
});

// Replaces the old local mock Notifier
final pharmacyOrdersProvider = FutureProvider<List<PharmacyOrder>>((ref) async {
  final profile = await ref.watch(pharmacyProfileProvider.future);
  if (profile == null) return [];
  
  final res = await ref.read(pharmacyRepositoryProvider).fetchOrders(profile.id);
  return res.fold(
    (l) {
      // Fallback Orders Data
      return [
        PharmacyOrder(
          id: 'ORD-9281', patientName: 'Sarah Jenkins', patientId: 'P-9982', age: 45, gender: 'Female', time: '10:42 AM', status: 'New', isUrgent: true, doctorName: 'Dr. Emily Chen',
          items: [MedicineItem(name: 'Amoxicillin', dosage: '500mg', quantity: '30', instructions: 'Take 1 tablet every 8 hours')],
        ),
        PharmacyOrder(
          id: 'ORD-9278', patientName: 'Michael Chen', patientId: 'P-8821', age: 32, gender: 'Male', time: '09:15 AM', status: 'Preparing', doctorName: 'Dr. Alan Smith',
          items: [MedicineItem(name: 'Lisinopril', dosage: '10mg', quantity: '90', instructions: 'Take 1 tablet daily')],
        ),
        PharmacyOrder(
          id: 'ORD-9265', patientName: 'Emma Wilson', patientId: 'P-7734', age: 28, gender: 'Female', time: '08:30 AM', status: 'Ready', doctorName: 'Dr. Sarah Johnson',
          items: [MedicineItem(name: 'Ventolin HFA', dosage: '90mcg', quantity: '1', instructions: '2 puffs as needed')],
        ),
      ];
    },
    (r) => r.isNotEmpty ? r : [
        PharmacyOrder(
          id: 'ORD-9281', patientName: 'Sarah Jenkins', patientId: 'P-9982', age: 45, gender: 'Female', time: '10:42 AM', status: 'New', isUrgent: true, doctorName: 'Dr. Emily Chen',
          items: [MedicineItem(name: 'Amoxicillin', dosage: '500mg', quantity: '30', instructions: 'Take 1 tablet every 8 hours')],
        ),
        PharmacyOrder(
          id: 'ORD-9278', patientName: 'Michael Chen', patientId: 'P-8821', age: 32, gender: 'Male', time: '09:15 AM', status: 'Preparing', doctorName: 'Dr. Alan Smith',
          items: [MedicineItem(name: 'Lisinopril', dosage: '10mg', quantity: '90', instructions: 'Take 1 tablet daily')],
        ),
    ], // Return mock if DB is empty
  );
});
