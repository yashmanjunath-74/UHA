import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'patient_detail_screen.dart';

class DoctorHomeTab extends ConsumerWidget {
  const DoctorHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monday, Oct 24, 2023', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      SizedBox(height: 4),
                      Text('Good Morning, Dr. Sarah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
                      child: const Icon(Icons.notifications_outlined, color: Color(0xFF475569)),
                    ),
                    Positioned(top: 10, right: 10, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1.5))))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Stats Row ────────────────────────────────────────
            Row(children: [
              _statCard('8', 'Total Appts', const Color(0xFF10B981)),
              const SizedBox(width: 12),
              _statCard('2', 'Waiting', const Color(0xFFF59E0B)),
              const SizedBox(width: 12),
              _statCard('4h', 'Work Time', const Color(0xFF6366F1)),
            ]),
            const SizedBox(height: 24),

            // ── Today's Schedule ─────────────────────────────────
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Today's Schedule", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              TextButton(onPressed: () {}, child: const Text('View Calendar', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 13))),
            ]),
            const SizedBox(height: 12),

            // ── In Progress Card (highlighted) ───────────────────
            _buildInProgressCard(context),
            const SizedBox(height: 12),

            // ── Upcoming Appointments ────────────────────────────
            const Text('UP NEXT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 1)),
            const SizedBox(height: 10),
            _appointmentCard(context, '11:30 AM', 'Checked In', 'Jane Roe', 'Female, 32', 'Annual Checkup', true, const Color(0xFF10B981), 'JR'),
            const SizedBox(height: 10),
            _appointmentCard(context, '01:00 PM', 'Pending', 'Robert Brown', 'Male, 60', 'Back Pain Review', false, const Color(0xFFF59E0B), 'RB'),
            const SizedBox(height: 10),
            _appointmentCard(context, '02:30 PM', 'Pending', 'Emma Lewis', 'Female, 8', 'Vaccination', false, const Color(0xFF94A3B8), 'EL'),
            const SizedBox(height: 10),
            _appointmentCard(context, '04:00 PM', 'Pending', 'Arjun Sharma', 'Male, 52', 'Cardiology Follow-up', false, const Color(0xFF94A3B8), 'AS'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ]),
      ),
    );
  }

  Widget _buildInProgressCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientDetailScreen(patientName: 'John Doe', gender: 'Male', age: 45, condition: 'High Fever'))),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: const Text('IN PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
            const Spacer(),
            const Text('10:00 AM – 10:30 AM', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.person, color: Color(0xFF10B981), size: 28)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('John Doe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 3),
              Text('Male, 45 yrs  •  High Fever', style: TextStyle(fontSize: 13, color: Colors.white70)),
            ])),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            _inProgressBtn(Icons.description_outlined, 'Details', false),
            const SizedBox(width: 12),
            _inProgressBtn(Icons.play_arrow_rounded, 'Resume', true),
          ]),
        ]),
      ),
    );
  }

  Widget _inProgressBtn(IconData icon, String label, bool filled) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: filled ? const Color(0xFF10B981) : Colors.white),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: filled ? const Color(0xFF10B981) : Colors.white)),
        ]),
      ),
    );
  }

  Widget _appointmentCard(BuildContext context, String time, String status, String name, String demographic, String reason, bool isCheckedIn, Color statusColor, String initials) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailScreen(patientName: name, gender: demographic.split(',')[0].trim(), age: int.tryParse(demographic.split(',')[1].trim().replaceAll(RegExp(r'[^0-9]'), '')) ?? 30, condition: reason))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
            const SizedBox(width: 10),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
              child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor))),
            const Spacer(),
            const Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            CircleAvatar(radius: 20, backgroundColor: const Color(0xFFE8F5F1), child: Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 13))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B))),
              Text('$demographic  •  $reason', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ])),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: isCheckedIn ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCheckedIn ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
                disabledBackgroundColor: const Color(0xFFF1F5F9),
                foregroundColor: isCheckedIn ? Colors.white : const Color(0xFF94A3B8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text('Start Consultation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isCheckedIn ? Colors.white : const Color(0xFF94A3B8))),
            ),
          ),
        ]),
      ),
    );
  }
}
