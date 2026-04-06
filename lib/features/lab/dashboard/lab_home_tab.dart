import 'package:flutter/material.dart';

class LabHomeTab extends StatelessWidget {
  const LabHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Monday, Oct 24', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                SizedBox(height: 4),
                Text('City Diagnostics Lab', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                Text('Universal Health App', style: TextStyle(fontSize: 13, color: Color(0xFF10B981), fontWeight: FontWeight.w500)),
              ]),
              CircleAvatar(radius: 22, backgroundColor: Colors.white, child: const Icon(Icons.biotech, color: Color(0xFF10B981))),
            ]),
            const SizedBox(height: 24),

            // Overview Stats
            Row(children: [
              _statItem('18', 'Tests Today', const Color(0xFF10B981), Icons.assignment_turned_in_outlined),
              const SizedBox(width: 12),
              _statItem('5', 'Pending Reports', const Color(0xFFF59E0B), Icons.pending_actions),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _statItem('₹14,500', 'Today\'s Revenue', const Color(0xFF6366F1), Icons.payments_outlined),
              const SizedBox(width: 12),
              _statItem('4.9', 'Lab Rating', const Color(0xFF8B5CF6), Icons.star_outline_rounded),
            ]),
            const SizedBox(height: 24),

            // Payout Banner
            _payoutBanner(),
            const SizedBox(height: 24),

            // Recent Bookings
            const Text('Upcoming Tests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            _testCard('Sarah Jenkins', 'Complete Blood Count (CBC)', '10:30 AM', 'Confirmed', const Color(0xFF10B981)),
            const SizedBox(height: 10),
            _testCard('Raj Kumar', 'Lipid Profile', '11:15 AM', 'Arrival Pending', const Color(0xFFF59E0B)),
            const SizedBox(height: 10),
            _testCard('Priya Sharma', 'Blood Sugar (F)', '12:00 PM', 'Confirmed', const Color(0xFF10B981)),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, Color color, IconData icon) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ]),
        ),
      );

  Widget _payoutBanner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Instant Payout Ready', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Available Balance: ₹8,900', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ]),
          Icon(Icons.arrow_circle_right_rounded, color: Colors.white, size: 32),
        ]),
      );

  Widget _testCard(String patient, String testName, String time, String status, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: color, width: 4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(patient, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Text(testName, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))),
          ]),
        ]),
      );
}
