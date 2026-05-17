import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import '../controller/hospital_controller.dart';
import '../../../models/hospital_admission_model.dart';

class HospitalPatientsScreen extends ConsumerStatefulWidget {
  const HospitalPatientsScreen({super.key});

  @override
  ConsumerState<HospitalPatientsScreen> createState() => _HospitalPatientsScreenState();
}

class _HospitalPatientsScreenState extends ConsumerState<HospitalPatientsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Admitted', 'OPD', 'Emergency', 'Discharged'];

  // Remove mock data, we will fetch from provider

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HospitalAdmissionModel> _filteredPatients(List<HospitalAdmissionModel> allPatients) {
    var filtered = _selectedFilter == 'All'
        ? allPatients
        : allPatients.where((p) => p.status == _selectedFilter).toList();
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.patientName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              p.patientDisplayId.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatBadge('Total', '248', const Color(0xFF6366F1)),
                  const SizedBox(width: 12),
                  _buildStatBadge('Admitted', '185', const Color(0xFF10B981)),
                  const SizedBox(width: 12),
                  _buildStatBadge('Emergency', '12', const Color(0xFFEF4444)),
                  const SizedBox(width: 12),
                  _buildStatBadge('OPD', '51', const Color(0xFFF59E0B)),
                ],
              ),
              const SizedBox(height: 16),
              // Search
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by name or ID...',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final selected = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedFilter = f),
                        selectedColor: AppColors.primary.withOpacity(0.15),
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected ? AppColors.primary : const Color(0xFF64748B),
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                        backgroundColor: const Color(0xFFF1F5F9),
                        side: BorderSide(
                          color: selected ? AppColors.primary : Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        // List
        Expanded(
          child: ref.watch(hospitalAdmissionsProvider).when(
            data: (allPatients) {
              final displayedPatients = _filteredPatients(allPatients);
              if (displayedPatients.isEmpty) {
                return const Center(child: Text('No patients found.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: displayedPatients.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _buildPatientCard(displayedPatients[index]),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(HospitalAdmissionModel patient) {
    Color statusColor;
    switch (patient.status) {
      case 'Emergency':
        statusColor = const Color(0xFFEF4444);
        break;
      case 'OPD':
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'Discharged':
        statusColor = const Color(0xFF64748B);
        break;
      case 'Admitted':
      default:
        statusColor = const Color(0xFF10B981);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: patient.gender == 'M' || patient.gender == 'Male' ? const Color(0xFFE8F1FF) : const Color(0xFFFFE8F1),
            child: Text(
              patient.patientName.isNotEmpty ? patient.patientName[0].toUpperCase() : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: patient.gender == 'M' || patient.gender == 'Male' ? const Color(0xFF2C6BFF) : const Color(0xFFFF2C7D),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(patient.patientName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B))),
                    const SizedBox(width: 6),
                    Text('${patient.age}y', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 3),
                Text('${patient.patientDisplayId} • ${patient.ward}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                Text('${patient.doctorName} • Bed: ${patient.bedNo}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(patient.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
              const SizedBox(height: 4),
              Text(patient.admittedSince, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}
