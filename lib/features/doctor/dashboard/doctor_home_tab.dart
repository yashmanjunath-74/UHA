import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'patient_detail_screen.dart';
import '../controller/doctor_controller.dart';
import '../../auth/controller/auth_controller.dart';
import 'package:intl/intl.dart';

class DoctorHomeTab extends ConsumerWidget {
  const DoctorHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorProfileProvider);
    final appointmentsAsync = ref.watch(doctorAppointmentsProvider);

    return doctorAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (doctor) {
        if (doctor == null) return const Center(child: Text('Doctor profile not found'));

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()), 
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          Text('Welcome, Dr. ${doctor.fullName.split(' ').last}', 
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ),
                    const CircleAvatar(radius: 22, backgroundColor: Color(0xFFE8F5F1), child: Icon(Icons.notifications_outlined, color: Color(0xFF475569))),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Stats Row ────────────────────────────────────────
                appointmentsAsync.when(
                  data: (appointments) {
                    final todayAppts = appointments.where((a) => DateUtils.isSameDay(a.scheduledAt, DateTime.now())).toList();
                    final waitingCount = todayAppts.where((a) => a.status == 'pending').length;
                    
                    return Row(children: [
                      _statCard('${todayAppts.length}', 'Today', const Color(0xFF10B981)),
                      const SizedBox(width: 12),
                      _statCard('$waitingCount', 'Pending', const Color(0xFFF59E0B)),
                      const SizedBox(width: 12),
                      _statCard('${appointments.length}', 'Total', const Color(0xFF6366F1)),
                    ]);
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, s) => const SizedBox(),
                ),
                const SizedBox(height: 32),

                // ── Schedule ─────────────────────────────────
                const Text("Today's Schedule", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),

                appointmentsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Error: $e'),
                  data: (appointments) {
                    final todayAppts = appointments.where((a) => DateUtils.isSameDay(a.scheduledAt, DateTime.now())).toList();
                    final nextAppts = appointments.where((a) => a.scheduledAt.isAfter(DateTime.now()) && !DateUtils.isSameDay(a.scheduledAt, DateTime.now())).toList();

                    if (todayAppts.isEmpty && nextAppts.isEmpty) {
                      return _buildEmptyState();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todayAppts.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: const Text('No appointments for today.', style: TextStyle(color: Color(0xFF64748B))),
                          ),
                        ...todayAppts.map((appt) => _PatientAppointmentCard(appt: appt)),
                        
                        if (nextAppts.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text("Upcoming Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 12),
                          ...nextAppts.take(5).map((appt) => _PatientAppointmentCard(appt: appt)),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Column(children: [
        Icon(Icons.calendar_today, size: 48, color: Color(0xFFCBD5E1)),
        SizedBox(height: 16),
        Text('No appointments found.', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
      ]),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ]),
      ),
    );
  }
}

class _PatientAppointmentCard extends ConsumerWidget {
  final dynamic appt;
  const _PatientAppointmentCard({required this.appt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider(appt.patientId));

    return userAsync.when(
      loading: () => const Padding(padding: EdgeInsets.all(8.0), child: LinearProgressIndicator()),
      error: (e, s) => Text('Error loading user: $e'),
      data: (userData) {
        final name = userData?['name'] ?? "Patient #${appt.patientId.substring(0, 4)}";
        final isToday = DateUtils.isSameDay(appt.scheduledAt, DateTime.now());
        final timeStr = isToday ? DateFormat('hh:mm A').format(appt.scheduledAt) : DateFormat('MMM d, hh:mm A').format(appt.scheduledAt);

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailScreen(patientId: appt.patientId))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(children: [
              Row(children: [
                CircleAvatar(radius: 20, backgroundColor: const Color(0xFFF1F5F9), child: Text(name[0], style: const TextStyle(color: Color(0xFF10B981)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(timeStr, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: (appt.status == 'completed' ? Colors.grey : const Color(0xFF10B981)).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(appt.status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: appt.status == 'completed' ? Colors.grey : const Color(0xFF10B981))),
                ),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: appt.status == 'completed' ? null : () {
                    ref.read(doctorControllerProvider.notifier).updateAppointmentStatus(
                      appt.id, 
                      'completed',
                      (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $err'), backgroundColor: Colors.red)),
                      () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment marked as completed!'), backgroundColor: Color(0xFF10B981))),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appt.status == 'completed' ? const Color(0xFFF1F5F9) : const Color(0xFF10B981),
                    foregroundColor: appt.status == 'completed' ? const Color(0xFF94A3B8) : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(appt.status == 'completed' ? 'Consultation Finished' : 'Mark as Completed'),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
