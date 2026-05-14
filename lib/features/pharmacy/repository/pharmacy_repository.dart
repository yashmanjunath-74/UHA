import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/pharmacy_model.dart';
import '../providers/pharmacy_provider.dart';

class PharmacyRepository {
  final SupabaseClient _supabaseClient;

  PharmacyRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  FutureEither<PharmacyModel> fetchPharmacyProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('pharmacies')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
          
      if (response == null) {
        // Auto-create a default profile in the DB so foreign keys work
        final newProfile = {
          'user_id': userId,
          'name': 'My Pharmacy',
          'license_number': 'PENDING-LICENSE',
          'gst_number': 'PENDING-GST',
          'address': 'Update in Profile Settings',
          'city': 'Unknown',
          'verification_status': 'pending'
        };
        
        final insertResponse = await _supabaseClient
            .from('pharmacies')
            .insert(newProfile)
            .select()
            .single();
            
        return right(PharmacyModel.fromMap(insertResponse));
      }
      
      return right(PharmacyModel.fromMap(response));
    } catch (e) {
      return left(Failure('Failed to fetch pharmacy profile: ${e.toString()}'));
    }
  }

  FutureEither<List<Map<String, dynamic>>> fetchInventory(String pharmacyId) async {
    try {
      final response = await _supabaseClient
          .from('pharmacy_inventory')
          .select()
          .eq('pharmacy_id', pharmacyId)
          .order('name', ascending: true);
      return right(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return left(Failure('Failed to fetch inventory: ${e.toString()}'));
    }
  }

  FutureEither<Map<String, dynamic>> addInventoryItem(Map<String, dynamic> item) async {
    try {
      final response = await _supabaseClient
          .from('pharmacy_inventory')
          .insert(item)
          .select()
          .single();
      return right(response);
    } catch (e) {
      return left(Failure('Failed to add inventory item: ${e.toString()}'));
    }
  }

  FutureEither<List<PharmacyOrder>> fetchOrders(String pharmacyId) async {
    try {
      final response = await _supabaseClient
          .from('pharmacy_orders')
          .select()
          .eq('pharmacy_id', pharmacyId)
          .order('created_at', ascending: false);
      
      final orders = (response as List).map((data) {
        return PharmacyOrder(
          id: data['id'].toString(),
          patientName: data['patient_name'] ?? 'Unknown Patient',
          patientId: data['patient_id']?.toString() ?? '',
          age: data['patient_age'] ?? 0,
          gender: data['patient_gender'] ?? 'Unknown',
          time: data['created_at'].toString(),
          status: data['status'] ?? 'New',
          isUrgent: data['is_urgent'] ?? false,
          doctorName: data['doctor_name'] ?? 'Unknown Doctor',
          items: (data['items'] as List<dynamic>?)?.map((item) {
            return MedicineItem(
              name: item['name'] ?? '',
              dosage: item['dosage'] ?? '',
              quantity: item['quantity']?.toString() ?? '1',
              instructions: item['instructions'] ?? '',
            );
          }).toList() ?? [],
        );
      }).toList();

      return right(orders);
    } catch (e) {
      return left(Failure('Failed to fetch orders: ${e.toString()}'));
    }
  }

  FutureEither<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _supabaseClient
          .from('pharmacy_orders')
          .update({'status': status})
          .eq('id', orderId);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to update order status: ${e.toString()}'));
    }
  }

  FutureEither<List<PharmacyModel>> fetchAllPharmacies() async {
    try {
      final response = await _supabaseClient.from('pharmacies').select();
      final list = (response as List).map((data) => PharmacyModel.fromMap(data)).toList();
      return right(list);
    } catch (e) {
      return left(Failure('Failed to fetch pharmacies: ${e.toString()}'));
    }
  }

  FutureEither<void> placeOrder(Map<String, dynamic> orderData) async {
    try {
      await _supabaseClient.from('pharmacy_orders').insert(orderData);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to place order: ${e.toString()}'));
    }
  }
}
