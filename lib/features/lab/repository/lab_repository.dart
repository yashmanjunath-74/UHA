import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/lab_model.dart';
import 'package:fpdart/fpdart.dart';

class LabRepository {
  final SupabaseClient supabaseClient;

  LabRepository({required this.supabaseClient});

  FutureEither<LabModel> fetchLabProfile(String userId) async {
    try {
      final res = await supabaseClient
          .from('labs')
          .select()
          .or('user_id.eq.$userId,id.eq.$userId')
          .maybeSingle();

      if (res != null) {
        return right(LabModel.fromMap(res));
      }
      return left(const Failure('Lab profile not found'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<Map<String, dynamic>>> fetchLabOrders(String labId) async {
    try {
      final res = await supabaseClient
          .from('lab_orders')
          .select()
          .eq('lab_id', labId)
          .order('created_at', ascending: false);
      return right(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<Map<String, dynamic>>> fetchPatientLabOrders(String patientId) async {
    try {
      final res = await supabaseClient
          .from('lab_orders')
          .select()
          .eq('patient_id', patientId)
          .order('created_at', ascending: false);
      return right(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateOrderStatus(String orderId, String status, {String? resultUrl}) async {
    try {
      final updateData = {'status': status};
      if (resultUrl != null) {
        updateData['result_url'] = resultUrl;
      }
      await supabaseClient
          .from('lab_orders')
          .update(updateData)
          .eq('id', orderId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> placeOrder(Map<String, dynamic> orderData) async {
    try {
      await supabaseClient.from('lab_orders').insert(orderData);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<LabModel>> fetchAllLabs() async {
    try {
      final res = await supabaseClient.from('labs').select();
      final labs = (res as List).map((map) => LabModel.fromMap(map)).toList();
      return right(labs);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> uploadResultImage(String orderId, File file) async {
    try {
      final fileName = 'result_${orderId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabaseClient.storage.from('lab_documents').upload(fileName, file);
      final url = supabaseClient.storage.from('lab_documents').getPublicUrl(fileName);
      return right(url);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateLabTests(String labId, List<String> tests) async {
    try {
      await supabaseClient
          .from('labs')
          .update({'test_types': tests})
          .eq('id', labId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
