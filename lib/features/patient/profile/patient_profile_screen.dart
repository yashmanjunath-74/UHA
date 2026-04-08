import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/patient_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/constants.dart';
import '../../../models/patient_model.dart';

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.session?.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAT9n9ShLulkVf7EaIkBlA_1jEI3H6yDNQRcs1P3Bm7YnkYUGDiCGgeHItllZs8KdbK6_exNS8alQdRYZ-1FIww_h4j0Avm7nUsHxl_chHwMEWjULyNHUIwKHhlahSojkbtLwQRn7cIgAH1nEGr7IWQ5m6Hy6cZrT_stf8SsCvdI6wCU_iKjHGNrxaSXocN5czfIAG0y0-D22QFfZvittjNDt2pVPzAnTPTb5Qho_5ZH_HcImUxBfVSrvwA3Pgp519HhgmWNU1NRLvA',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      authState.userRole?.toUpperCase() ?? 'PATIENT',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'User Email',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildProfileItem(Icons.person_outline, 'Edit Profile', () {}),
                  _buildProfileItem(Icons.medical_services_outlined, 'My Health Records', () {
                     Routemaster.of(context).push(AppConstants.routePatientDigitalFile);
                  }),
                  _buildProfileItem(Icons.history_rounded, 'Medical Timeline', () {
                     Routemaster.of(context).push(AppConstants.routePatientTimeline);
                  }),
                  _buildProfileItem(Icons.settings_outlined, 'Settings', () {}),
                  _buildProfileItem(Icons.help_outline_rounded, 'Help & Support', () {}),
                  const SizedBox(height: 24),
                  
                  if (user != null)
                    ref.watch(patientProfileProvider(user.id)).when(
                      data: (patient) => _buildPatientHealthInfo(patient),
                      loading: () => const CircularProgressIndicator(),
                      error: (err, _) => Text('Error loading health info: ${err.toString()}'),
                    ),
                    
                  const SizedBox(height: 40),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).signOut();
                        if (context.mounted) {
                          Routemaster.of(context).replace(AppConstants.routeLogin);
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      label: const Text(
                        'Logout Account',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: const BorderSide(color: Color(0xFFFFEBEE)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF64748B), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF0F172A),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFCBD5E1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
    );
  }

  Widget _buildPatientHealthInfo(PatientModel patient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          _buildHealthRow('Blood Group', patient.bloodGroup ?? 'Unknown'),
          _buildHealthRow('Gender', patient.gender?.name ?? 'Unknown'),
          _buildHealthRow('Allergies', patient.allergies.isEmpty ? 'None' : patient.allergies.join(', ')),
          _buildHealthRow('Conditions', patient.chronicConditions.isEmpty ? 'None' : patient.chronicConditions.join(', ')),
        ],
      ),
    );
  }

  Widget _buildHealthRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 13)),
        ],
      ),
    );
  }
}
