import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/doctor_model.dart';
import '../../../models/appointment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorRepositoryProvider = Provider((ref) => DoctorRepository(supabaseClient: Supabase.instance.client));

class DoctorRepository {
  final SupabaseClient _supabaseClient;

  DoctorRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Fetch a doctor profile by their user ID
  FutureEither<DoctorModel> fetchDoctorProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('doctors')
          .select()
          .eq('id', userId)
          .single();

      return right(DoctorModel.fromMap(response));
    } catch (e) {
      return left(Failure('Failed to fetch doctor profile: ${e.toString()}'));
    }
  }

  /// Search for doctors by specialty or name
  FutureEither<List<DoctorModel>> searchDoctors({String? specialty, String? query}) async {
    try {
      var request = _supabaseClient.from('doctors').select();

      if (specialty != null && specialty != 'All') {
        request = request.ilike('specialty', '%$specialty%');
      }

      if (query != null && query.isNotEmpty) {
        request = request.ilike('full_name', '%$query%');
      }

      final response = await request;
      
      final doctors = (response as List)
          .map((data) => DoctorModel.fromMap(data as Map<String, dynamic>))
          .toList();

      return right(doctors);
    } catch (e) {
      return left(Failure('Failed to search doctors: ${e.toString()}'));
    }
  }

  /// Get top rated or featured doctors (placeholder for now)
  FutureEither<List<DoctorModel>> getTopDoctors() async {
    try {
      final response = await _supabaseClient
          .from('doctors')
          .select()
          .limit(10);

      final doctors = (response as List)
          .map((data) => DoctorModel.fromMap(data as Map<String, dynamic>))
          .toList();

      return right(doctors);
    } catch (e) {
      return left(Failure('Failed to get top doctors: ${e.toString()}'));
    }
  }

  /// Fetch appointments for a doctor
  FutureEither<List<AppointmentModel>> fetchDoctorAppointments(String doctorId) async {
    try {
      final response = await _supabaseClient
          .from('appointments')
          .select('*')
          .eq('doctor_id', doctorId)
          .order('scheduled_at', ascending: true);

      final appointments = (response as List)
          .map((data) => AppointmentModel.fromMap(data as Map<String, dynamic>))
          .toList();

      return right(appointments);
    } catch (e) {
      return left(Failure('Failed to fetch doctor appointments: ${e.toString()}'));
    }
  }

  /// Update doctor availability/status
  FutureEither<void> updateDoctorStatus(String doctorId, String status) async {
    try {
      await _supabaseClient
          .from('doctors')
          .update({'status': status})
          .eq('id', doctorId);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to update doctor status: ${e.toString()}'));
    }
  }

  /// Update an appointment's status
  FutureEither<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await _supabaseClient
          .from('appointments')
          .update({'status': status})
          .eq('id', appointmentId);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to update appointment status: ${e.toString()}'));
    }
  }
}
