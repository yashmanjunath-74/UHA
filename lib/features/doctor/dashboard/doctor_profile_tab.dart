import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/constants/constants.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/doctor_controller.dart';

class DoctorProfileTab extends ConsumerWidget {
  const DoctorProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorProfileProvider);

    return doctorAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
      data: (doctor) {
        if (doctor == null) {
          return const Center(child: Text('Doctor profile data not found in database.'));
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(children: [
              // ── Profile Hero ─────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(children: [
                  Stack(alignment: Alignment.bottomRight, children: [
                    CircleAvatar(
                      radius: 48, 
                      backgroundColor: Colors.white.withOpacity(0.2), 
                      backgroundImage: doctor.avatarUrl != null ? NetworkImage(doctor.avatarUrl!) : null,
                      child: doctor.avatarUrl == null ? const Icon(Icons.person, size: 56, color: Colors.white) : null
                    ),
                    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)]),
                      child: const Icon(Icons.edit, size: 16, color: Color(0xFF10B981))),
                  ]),
                  const SizedBox(height: 14),
                  Text('Dr. ${doctor.fullName}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('${doctor.specialty}  •  ${doctor.licenseNumber}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _heroStat('N/A', 'Patients'),
                    Container(width: 1, height: 30, color: Colors.white24),
                    _heroStat('${doctor.yearsOfExperience} yrs', 'Experience'),
                    Container(width: 1, height: 30, color: Colors.white24),
                    _heroStat('4.8 ★', 'Rating'),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Details ───────────────────────────────────────
              _sectionCard([
                _tileItem(Icons.school_outlined, 'Qualification', doctor.qualification, const Color(0xFF8B5CF6)),
                _divider(),
                _tileItem(Icons.location_on_outlined, 'Clinic Address', doctor.clinicAddress ?? 'Not provided', const Color(0xFF10B981)),
                _divider(),
                _tileItem(Icons.phone_outlined, 'Work Phone', doctor.workPhone, const Color(0xFF10B981)),
              ]),
              const SizedBox(height: 16),

              // ── Settings ─────────────────────────────────────────
              const Align(alignment: Alignment.centerLeft, child: Text('Account Settings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
              const SizedBox(height: 10),
              _sectionCard([
                _settingItem(Icons.notifications_outlined, 'Notifications', const Color(0xFF6366F1), trailing: Switch.adaptive(value: true, onChanged: (_){}, activeColor: const Color(0xFF10B981))),
                _divider(),
                _settingItem(Icons.schedule_outlined, 'Availability Schedule', const Color(0xFF10B981), trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1))),
                _divider(),
                _settingItem(Icons.lock_outline, 'Privacy & Security', const Color(0xFF2C6BFF), trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1))),
              ]),
              const SizedBox(height: 24),

              // ── Logout ────────────────────────────────────────────
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
          ),
        );
      },
    );
  }

  Widget _heroStat(String value, String label) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
  ]);

  Widget _sectionCard(List<Widget> children) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
    child: Column(children: children),
  );

  Widget _tileItem(IconData icon, String title, String subtitle, Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ])),
    ]),
  );

  Widget _settingItem(IconData icon, String title, Color color, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 14),
      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1E293B)))),
      if (trailing != null) trailing,
    ]),
  );

  Widget _divider() => const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFF1F5F9));

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Log Out?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to log out of your doctor account?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await ref.read(authProvider.notifier).signOut();
            if (context.mounted) Routemaster.of(context).replace(AppConstants.routeLogin);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Log Out'),
        ),
      ],
    ));
  }
}
