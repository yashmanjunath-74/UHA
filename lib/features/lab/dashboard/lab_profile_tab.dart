import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/constants/constants.dart';
import '../../auth/controller/auth_controller.dart';

class LabProfileTab extends ConsumerWidget {
  const LabProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(children: [
          Stack(alignment: Alignment.bottomRight, children: [
            CircleAvatar(radius: 54, backgroundColor: Colors.white24, child: const Icon(Icons.biotech_rounded, size: 60, color: Colors.white)),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]), child: const Icon(Icons.edit, size: 18, color: Color(0xFF10B981))),
          ]),
          const SizedBox(height: 20),
          const Text('City Diagnostics Lab', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Reg: DL-KA-2023-4291', style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5)),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _heroStat('1,240', 'Tests'),
            Container(width: 1, height: 30, color: Colors.white24),
            _heroStat('4.9 ★', 'Rating'),
            Container(width: 1, height: 30, color: Colors.white24),
            _heroStat('24h', 'Open'),
          ]),
        ]),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          children: [
            _tileSection('Account Details', [
              _tile(Icons.location_on_outlined, 'Address', '12 MG Road, Bangalore - 560001', const Color(0xFF2C6BFF)),
              _tile(Icons.phone_outlined, 'Contact', '+91 80 1234 5678', const Color(0xFF10B981)),
              _tile(Icons.email_outlined, 'Email', 'citylab@uha.health', const Color(0xFFF59E0B)),
            ]),
            const SizedBox(height: 24),
            _tileSection('Operations', [
              _tile(Icons.access_time_rounded, 'Operating Hours', 'Mon - Sat (08:00 - 20:00)', const Color(0xFF6366F1)),
              _tile(Icons.biotech_outlined, 'Accreditations', 'NABL, ISO 15189', const Color(0xFF8B5CF6)),
            ]),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => _confirmLogout(context, ref),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFFECACA))),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                  SizedBox(width: 10),
                  Text('Logout Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                ]),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _heroStat(String value, String label) => Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  ]);

  Widget _tileSection(String title, List<Widget> tiles) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(children: tiles),
    ),
  ]);

  Widget _tile(IconData icon, String title, String subtitle, Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ])),
      const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
    ]),
  );

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to sign out? You will need to login again to access findings.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B)))),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await ref.read(authProvider.notifier).signOut();
            if (context.mounted) Routemaster.of(context).replace(AppConstants.routeLogin);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Logout'),
        ),
      ],
    ));
  }
}
