import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import '../controller/hospital_controller.dart';
import '../../../models/hospital_staff_model.dart';

class HospitalStaffScreen extends ConsumerStatefulWidget {
  const HospitalStaffScreen({super.key});

  @override
  ConsumerState<HospitalStaffScreen> createState() => _HospitalStaffScreenState();
}

class _HospitalStaffScreenState extends ConsumerState<HospitalStaffScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  // Remove mock staff data, we will fetch from provider

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'On Duty': return const Color(0xFF10B981);
      case 'Off Duty': return const Color(0xFF64748B);
      case 'On Leave': return const Color(0xFFF59E0B);
      default: return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatBox('Doctors', '28', const Color(0xFF2C6BFF)),
                  const SizedBox(width: 12),
                  _buildStatBox('Nurses', '64', const Color(0xFF10B981)),
                  const SizedBox(width: 12),
                  _buildStatBox('On Duty', '42', const Color(0xFF6366F1)),
                  const SizedBox(width: 12),
                  _buildStatBox('On Leave', '6', const Color(0xFFF59E0B)),
                ],
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: const Color(0xFF94A3B8),
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Doctors'),
                  Tab(text: 'Nursing Staff'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ref.watch(hospitalStaffProvider).when(
            data: (staffList) {
              final doctors = staffList.where((s) => s.isDoctor).toList();
              final nurses = staffList.where((s) => !s.isDoctor).toList();
              
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildStaffList(doctors, isDoctors: true),
                  _buildStaffList(nurses, isDoctors: false),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffList(List<HospitalStaffModel> list, {required bool isDoctors}) {
    if (list.isEmpty) {
      return Center(child: Text('No ${isDoctors ? 'doctors' : 'nurses'} found.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final staff = list[index];
        final statusColor = _statusColor(staff.status);
        final avatarText = staff.name.length >= 2 ? staff.name.substring(0, 2).toUpperCase() : '??';
        final roleColor = isDoctors ? const Color(0xFF2C6BFF) : const Color(0xFF10B981);
        
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
                radius: 24,
                backgroundColor: roleColor.withOpacity(0.15),
                child: Text(avatarText,
                    style: TextStyle(fontWeight: FontWeight.bold, color: roleColor, fontSize: 14)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(staff.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B))),
                    const SizedBox(height: 3),
                    Text('${staff.department} • ${staff.role}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    Text('Phone: ${staff.phone}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(staff.status,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
