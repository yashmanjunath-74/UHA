import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/doctor_controller.dart';
import '../../patient/controller/patient_controller.dart';
import '../../auth/controller/auth_controller.dart';
import 'patient_detail_screen.dart';

class DoctorPatientsTab extends ConsumerStatefulWidget {
  const DoctorPatientsTab({super.key});
  @override ConsumerState<DoctorPatientsTab> createState() => _DoctorPatientsTabState();
}

class _DoctorPatientsTabState extends ConsumerState<DoctorPatientsTab> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All';
  final _filters = ['All', 'Today', 'Critical', 'Chronic', 'Pediatric'];

  @override void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(doctorPatientsProvider);

    return SafeArea(
      child: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(children: [
            Row(children: [
              const Expanded(child: Text('Patient Directory', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF475569))),
            ]),
            const SizedBox(height: 14),
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by name or ID…',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                filled: true, fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final active = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : const Color(0xFF64748B))),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        ),
        Expanded(
          child: patientsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
            data: (patientIds) {
              if (patientIds.isEmpty) {
                return _buildEmptyState();
              }
              
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: patientIds.length,
                itemBuilder: (context, i) {
                  final pid = patientIds[i];
                  return _PatientListItem(patientId: pid);
                },
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.people_outline, size: 48, color: Colors.grey[300]),
        const SizedBox(height: 16),
        const Text('No patients found in your history.', style: TextStyle(color: Colors.grey)),
      ]),
    );
  }
}

class _PatientListItem extends ConsumerWidget {
  final String patientId;
  const _PatientListItem({required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider(patientId));
    final profileAsync = ref.watch(patientProfileProvider(patientId));

    return userAsync.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox(),
      data: (userData) {
        final name = userData?['name'] ?? "Unknown Patient";
        
        return profileAsync.when(
          loading: () => _buildCard(context, name, null),
          error: (e, s) => _buildCard(context, name, null),
          data: (profile) => _buildCard(context, name, profile),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, String name, dynamic profile) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailScreen(patientId: patientId))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Row(children: [
          CircleAvatar(radius: 24, backgroundColor: const Color(0xFFE8F5F1), child: Text(name[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Text(profile != null ? '${profile.gender?.name ?? "N/A"}, ${profile.dateOfBirth ?? "N/A"}' : 'Clinical profile not setup', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Text('STABLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
          ),
        ]),
      ),
    );
  }
}
