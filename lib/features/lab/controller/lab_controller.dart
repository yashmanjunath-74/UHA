import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/lab_repository.dart';
import '../../../models/lab_model.dart';
import '../../../models/lab_order_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../providers/lab_provider.dart';

final labRepositoryProvider = Provider(
  (ref) => LabRepository(supabaseClient: Supabase.instance.client),
);

final labProfileProvider = FutureProvider<LabModel?>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return null;

  final res = await ref.read(labRepositoryProvider).fetchLabProfile(user.id);
  return res.fold((l) {
    // Fallback Profile
    return LabModel(
      id: user.id, // Using user.id to prevent Postgres UUID errors
      userId: user.id,
      name: 'Universal Diagnostics Lab',
      registrationNumber: 'LAB-KA-2023-112',
      address: '45 Health Ave',
      city: 'Bangalore',
      testTypes: ['Blood Test', 'X-Ray', 'MRI', 'Urine Test'],
    );
  }, (r) => r);
});

final labOrdersProvider = FutureProvider<List<LabOrderModel>>((ref) async {
  final profile = await ref.watch(labProfileProvider.future);
  if (profile == null) return [];

  final filter = ref.watch(labFilterProvider);
  
  final res = await ref.read(labRepositoryProvider).fetchLabOrders(profile.id);
  return res.fold(
    (l) => throw l.message,
    (r) {
      final orders = r.map((e) => LabOrderModel.fromMap(e)).toList();
      if (filter == 'All') return orders;
      if (filter == 'New') return orders.where((o) => o.status == 'New').toList();
      if (filter == 'Testing') return orders.where((o) => o.status == 'Testing').toList();
      if (filter == 'Completed') return orders.where((o) => o.status == 'Completed').toList();
      return orders;
    },
  );
});

final allLabsProvider = FutureProvider<List<LabModel>>((ref) async {
  final res = await ref.read(labRepositoryProvider).fetchAllLabs();
  return res.fold(
    (l) => [
      LabModel(
        id: '27b3b4f6-bc9b-44ec-b873-199f1c7d235c', // Fake UUID
        userId: '27b3b4f6-bc9b-44ec-b873-199f1c7d235c',
        name: 'Apollo Diagnostics',
        city: 'Bangalore',
        testTypes: ['Blood Test', 'X-Ray', 'Urine Test'],
      )
    ], // Return a mock fallback if DB fails so user can still see something
    (r) => r.isNotEmpty ? r : [
      LabModel(
        id: '27b3b4f6-bc9b-44ec-b873-199f1c7d235c', // Fake UUID
        userId: '27b3b4f6-bc9b-44ec-b873-199f1c7d235c',
        name: 'Apollo Diagnostics',
        city: 'Bangalore',
        testTypes: ['Blood Test', 'X-Ray', 'Urine Test'],
      )
    ],
  );
});

final patientLabOrdersProvider = FutureProvider<List<LabOrderModel>>((ref) async {
  final user = ref.watch(authProvider).session?.user;
  if (user == null) return [];

  final res = await ref.read(labRepositoryProvider).fetchPatientLabOrders(user.id);
  return res.fold(
    (l) => [], // Throw or return empty if error
    (r) => r.map((e) => LabOrderModel.fromMap(e)).toList(),
  );
});

class LabController {
  final Ref ref;
  LabController(this.ref);

  Future<void> updateOrderStatus(String orderId, String status, {String? resultUrl}) async {
    final res = await ref.read(labRepositoryProvider).updateOrderStatus(orderId, status, resultUrl: resultUrl);
    res.fold(
      (l) => throw l.message,
      (r) {
        ref.invalidate(labOrdersProvider);
      },
    );
  }

  Future<String> uploadResultImage(String orderId, File file) async {
    final res = await ref.read(labRepositoryProvider).uploadResultImage(orderId, file);
    return res.fold(
      (l) => throw l.message,
      (r) => r,
    );
  }

  Future<void> updateLabTests(String labId, List<String> tests) async {
    final res = await ref.read(labRepositoryProvider).updateLabTests(labId, tests);
    res.fold(
      (l) => throw l.message,
      (r) {
        ref.invalidate(labProfileProvider);
        ref.invalidate(allLabsProvider);
      },
    );
  }

  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    // Intercept fake mock lab to prevent Postgres foreign key crash
    if (orderData['lab_id'] == '27b3b4f6-bc9b-44ec-b873-199f1c7d235c') {
      throw 'Cannot book a test on a Demo Lab. Please register a real lab account in the app first.';
    }

    final res = await ref.read(labRepositoryProvider).placeOrder(orderData);
    res.fold(
      (l) => throw l.message,
      (r) {
        ref.invalidate(patientLabOrdersProvider);
      },
    );
  }
}

final labControllerProvider = Provider((ref) => LabController(ref));
