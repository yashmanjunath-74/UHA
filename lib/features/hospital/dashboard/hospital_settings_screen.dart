import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:unified_health_alliance/core/constants/constants.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/features/auth/controller/auth_controller.dart';

class HospitalSettingsScreen extends ConsumerWidget {
  const HospitalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    (authState.session?.user.email ?? 'H')[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hospital Administrator',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authState.session?.user.email ?? '',
                        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('✓ Approved', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Hospital Settings
          _sectionHeader('Hospital Configuration'),
          const SizedBox(height: 12),
          _buildSettingsGroup([
            _settingsTile(Icons.local_hospital_outlined, 'Hospital Profile', 'Update hospital details', const Color(0xFF2C6BFF)),
            _settingsTile(Icons.bed_outlined, 'Bed Management', 'Configure wards & beds', const Color(0xFF10B981)),
            _settingsTile(Icons.medical_services_outlined, 'Departments', 'Manage departments', const Color(0xFF6366F1)),
            _settingsTile(Icons.schedule_outlined, 'Shift Schedules', 'Configure staff shifts', const Color(0xFFF59E0B)),
          ]),
          const SizedBox(height: 24),

          // Notifications
          _sectionHeader('Notifications'),
          const SizedBox(height: 12),
          _buildSettingsGroup([
            _switchTile(Icons.notifications_outlined, 'Emergency Alerts', 'Receive critical alerts', true, const Color(0xFFEF4444)),
            _switchTile(Icons.email_outlined, 'Email Reports', 'Daily summary reports', false, const Color(0xFF6366F1)),
            _switchTile(Icons.sms_outlined, 'SMS Alerts', 'Receive SMS notifications', true, const Color(0xFF10B981)),
          ]),
          const SizedBox(height: 24),

          // Account
          _sectionHeader('Account'),
          const SizedBox(height: 12),
          _buildSettingsGroup([
            _settingsTile(Icons.lock_outline, 'Change Password', 'Update your credentials', const Color(0xFF64748B)),
            _settingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', 'View privacy policy', const Color(0xFF64748B)),
            _settingsTile(Icons.help_outline, 'Help & Support', 'Get help from UHA team', const Color(0xFF64748B)),
          ]),
          const SizedBox(height: 24),

          // Logout
          _sectionHeader('Session'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: ListTile(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to sign out of your UHA hospital account?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref.read(authProvider.notifier).signOut();
                  if (context.mounted) {
                    Routemaster.of(context).replace(AppConstants.routeLogin);
                  }
                }
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
              ),
              title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFEF4444), fontSize: 15)),
              subtitle: const Text('Sign out from your hospital account', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('UHA v1.0.0 • Unified Health Alliance', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              items[i],
              if (i < items.length - 1) const Divider(height: 1, indent: 68),
            ],
          );
        }),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1E293B))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: Color(0xFF94A3B8)),
      onTap: () {},
    );
  }

  Widget _switchTile(IconData icon, String title, String subtitle, bool value, Color color) {
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1E293B))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        trailing: Switch.adaptive(
          value: value,
          onChanged: (v) => setState(() => value = v),
          activeColor: AppColors.primary,
        ),
      );
    });
  }
}
