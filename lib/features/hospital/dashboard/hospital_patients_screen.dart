import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class HospitalPatientsScreen extends StatefulWidget {
  const HospitalPatientsScreen({super.key});

  @override
  State<HospitalPatientsScreen> createState() => _HospitalPatientsScreenState();
}

class _HospitalPatientsScreenState extends State<HospitalPatientsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Admitted', 'OPD', 'Emergency', 'Discharged'];

  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'Rajesh Kumar',
      'id': 'UHA-20241',
      'age': 45,
      'ward': 'Cardiology',
      'status': 'Admitted',
      'doctor': 'Dr. Sharma',
      'bedNo': 'A-12',
      'since': '2 days',
      'gender': 'M',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'name': 'Priya Patel',
      'id': 'UHA-20242',
      'age': 32,
      'ward': 'Maternity',
      'status': 'Admitted',
      'doctor': 'Dr. Mehta',
      'bedNo': 'B-05',
      'since': '1 day',
      'gender': 'F',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'name': 'Suresh Nair',
      'id': 'UHA-20243',
      'age': 67,
      'ward': 'ICU',
      'status': 'Emergency',
      'doctor': 'Dr. Singh',
      'bedNo': 'ICU-03',
      'since': '5 hrs',
      'gender': 'M',
      'statusColor': const Color(0xFFEF4444),
    },
    {
      'name': 'Anita Reddy',
      'id': 'UHA-20244',
      'age': 28,
      'ward': 'Orthopedics',
      'status': 'OPD',
      'doctor': 'Dr. Joseph',
      'bedNo': 'OPD-7',
      'since': 'Today',
      'gender': 'F',
      'statusColor': const Color(0xFF6366F1),
    },
    {
      'name': 'Vikas Gupta',
      'id': 'UHA-20245',
      'age': 55,
      'ward': 'Neurology',
      'status': 'Discharged',
      'doctor': 'Dr. Rao',
      'bedNo': '-',
      'since': 'Yesterday',
      'gender': 'M',
      'statusColor': const Color(0xFF64748B),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPatients {
    var filtered = _selectedFilter == 'All'
        ? _patients
        : _patients.where((p) => p['status'] == _selectedFilter).toList();
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
              p['id'].toLowerCase().contains(_searchController.text.toLowerCase()))
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
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: _filteredPatients.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildPatientCard(_filteredPatients[index]),
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

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    final statusColor = patient['statusColor'] as Color;
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
            backgroundColor: patient['gender'] == 'M' ? const Color(0xFFE8F1FF) : const Color(0xFFFFE8F1),
            child: Text(
              patient['name'][0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: patient['gender'] == 'M' ? const Color(0xFF2C6BFF) : const Color(0xFFFF2C7D),
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
                    Text(patient['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B))),
                    const SizedBox(width: 6),
                    Text('${patient['age']}y', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 3),
                Text('${patient['id']} • ${patient['ward']}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                Text('${patient['doctor']} • Bed: ${patient['bedNo']}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
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
                child: Text(patient['status'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
              const SizedBox(height: 4),
              Text(patient['since'], style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}
