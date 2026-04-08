import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/appointment_model.dart';

class AppointmentRepository {
  final SupabaseClient _supabaseClient;

  AppointmentRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Book a new appointment
  FutureEither<AppointmentModel> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    required double fee,
    String? notes,
  }) async {
    try {
      final response = await _supabaseClient.from('appointments').insert({
        'patient_id': patientId,
        'doctor_id': doctorId,
        'scheduled_at': scheduledAt.toIso8601String(),
        'status': 'pending',
        'fee': fee,
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return right(AppointmentModel.fromMap(response));
    } catch (e) {
      return left(Failure('Failed to book appointment: ${e.toString()}'));
    }
  }

  /// Fetch all appointments for a patient
  FutureEither<List<AppointmentModel>> fetchPatientAppointments(String patientId) async {
    try {
      final response = await _supabaseClient
          .from('appointments')
          .select()
          .eq('patient_id', patientId)
          .order('scheduled_at', ascending: false);

      final appointments = (response as List)
          .map((data) => AppointmentModel.fromMap(data as Map<String, dynamic>))
          .toList();

      return right(appointments);
    } catch (e) {
      return left(Failure('Failed to fetch appointments: ${e.toString()}'));
    }
  }

  /// Cancel an appointment
  FutureEither<void> cancelAppointment(String appointmentId) async {
    try {
      await _supabaseClient
          .from('appointments')
          .update({'status': 'cancelled'})
          .eq('id', appointmentId);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to cancel appointment: ${e.toString()}'));
    }
  }
}
