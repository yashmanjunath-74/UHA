import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/constants/constants.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/pharmacy_controller.dart';

class PharmacyProfileScreen extends ConsumerWidget {
  const PharmacyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(pharmacyProfileProvider);
    final ordersAsync = ref.watch(pharmacyOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          final orderCount = ordersAsync.maybeWhen(
            data: (orders) => orders.length.toString(),
            orElse: () => '-',
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(children: [
              // ── Profile Hero ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 20, offset: const Offset(0,8))],
                ),
                child: Column(children: [
                  Stack(alignment: Alignment.bottomRight, children: [
                    CircleAvatar(radius: 48, backgroundColor: Colors.white.withOpacity(0.2), child: const Icon(Icons.store, size: 52, color: Colors.white)),
                    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)]),
                      child: const Icon(Icons.edit, size: 16, color: Color(0xFF10B981))),
                  ]),
                  const SizedBox(height: 14),
                  Text(profile.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('${profile.licenseNumber ?? "N/A"}  •  GSTIN: ${profile.gstNumber ?? "N/A"}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _heroStat(orderCount, 'Orders'),
                    Container(width: 1, height: 30, color: Colors.white24),
                    _heroStat('4.8 ★', 'Rating'),
                    Container(width: 1, height: 30, color: Colors.white24),
                    _heroStat('24h', 'Open'),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Pharmacy Details ──────────────────────────────────────
              _sectionCard([
                _tile(Icons.location_on_outlined, 'Address', '${profile.address ?? "No address provided"} — ${profile.city ?? "Unknown City"}', const Color(0xFF2C6BFF)),
                _divider(),
                _tile(Icons.phone_outlined, 'Contact', 'Update in settings', const Color(0xFF10B981)),
                _divider(),
                _tile(Icons.email_outlined, 'Email', 'Update in settings', const Color(0xFF10B981)),
                _divider(),
                _tile(Icons.verified_outlined, 'Verification', profile.verificationStatus.name.toUpperCase(), const Color(0xFF8B5CF6)),
              ]),
              const SizedBox(height: 16),

              // ── Account Settings ──────────────────────────────────────
              const Align(alignment: Alignment.centerLeft, child: Text('Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
              const SizedBox(height: 10),
              _sectionCard([
                _settingTile(Icons.delivery_dining_rounded, 'Home Delivery', const Color(0xFF10B981), trailing: Switch.adaptive(value: true, onChanged: (_){}, activeColor: const Color(0xFF10B981))),
                _divider(),
                _settingTile(Icons.lock_outline, 'Privacy & Security', const Color(0xFF2C6BFF), trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1))),
                _divider(),
                _settingTile(Icons.help_outline, 'Support', const Color(0xFFF59E0B), trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1))),
              ]),
              const SizedBox(height: 24),

              // ── Logout ────────────────────────────────────────────────
              GestureDetector(
                onTap: () => _confirmLogout(context, ref),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFECACA))),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                    SizedBox(width: 10),
                    Text('Log Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                  ]),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget _heroStat(String value, String label) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
  ]);

  Widget _sectionCard(List<Widget> children) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
    child: Column(children: children),
  );

  Widget _tile(IconData icon, String title, String subtitle, Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ])),
    ]),
  );

  Widget _settingTile(IconData icon, String title, Color color, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1E293B)))),
      if (trailing != null) trailing,
    ]),
  );

  Widget _divider() => const Divider(height: 1, indent: 50, endIndent: 16, color: Color(0xFFF1F5F9));

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Log Out?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await ref.read(authRepositoryProvider).signOut();
            if (context.mounted) Routemaster.of(context).replace(AppConstants.routeLogin);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Log Out'),
        ),
      ],
    ));
  }
}
