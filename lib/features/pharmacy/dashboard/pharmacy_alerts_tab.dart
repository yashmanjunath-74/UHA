import 'package:flutter/material.dart';

class PharmacyAlertsTab extends StatelessWidget {
  const PharmacyAlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      _Alert(icon: Icons.warning_amber_rounded, color: const Color(0xFFEF4444), title: 'Low Stock: Amoxicillin 500mg', subtitle: 'Only 12 strips remaining. Reorder immediately.', time: '2 min ago', read: false),
      _Alert(icon: Icons.info_outline_rounded, color: const Color(0xFF2C6BFF), title: 'New Order #10237', subtitle: 'Sarah Jenkins — Metformin 1g × 60', time: '15 min ago', read: false),
      _Alert(icon: Icons.local_shipping_rounded, color: const Color(0xFF10B981), title: 'Delivery Completed', subtitle: 'Order #10231 delivered to patient Raj Kumar.', time: '1 hr ago', read: false),
      _Alert(icon: Icons.calendar_today_rounded, color: const Color(0xFFF59E0B), title: 'Expiry Alert: Insulin Pen', subtitle: 'Batch #A2291 expires on Nov 10, 2023.', time: '3 hrs ago', read: true),
      _Alert(icon: Icons.check_circle_outline_rounded, color: const Color(0xFF10B981), title: 'Payout Transferred', subtitle: '\$1,200.00 credited to your account. TXN-9982', time: 'Yesterday', read: true),
      _Alert(icon: Icons.medication_outlined, color: const Color(0xFF8B5CF6), title: 'Prescription Verification Required', subtitle: 'Order #10229 — Dr. Chen prescription needs review.', time: 'Yesterday', read: true),
      _Alert(icon: Icons.star_rounded, color: const Color(0xFFF59E0B), title: 'New Rating Received', subtitle: 'Patient Priya Sharma gave you ★ 5 stars!', time: '2 days ago', read: true),
    ];

    return SafeArea(
      child: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: Row(children: [
            const Expanded(child: Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
            TextButton(onPressed: () {}, child: const Text('Mark all read', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 13))),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: alerts.length,
            itemBuilder: (context, i) {
              final a = alerts[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: a.read ? Colors.white : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: a.read ? const Color(0xFFF1F5F9) : const Color(0xFF86EFAC)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: a.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(a.icon, color: a.color, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      if (!a.read) Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 6), decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                      Expanded(child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)))),
                    ]),
                    const SizedBox(height: 4),
                    Text(a.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    Text(a.time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ])),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _Alert {
  final IconData icon;
  final Color color;
  final String title, subtitle, time;
  final bool read;
  const _Alert({required this.icon, required this.color, required this.title, required this.subtitle, required this.time, required this.read});
}
