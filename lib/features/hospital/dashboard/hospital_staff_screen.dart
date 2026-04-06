import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class HospitalStaffScreen extends StatefulWidget {
  const HospitalStaffScreen({super.key});

  @override
  State<HospitalStaffScreen> createState() => _HospitalStaffScreenState();
}

class _HospitalStaffScreenState extends State<HospitalStaffScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _doctors = [
    {'name': 'Dr. Arjun Sharma', 'dept': 'Cardiology', 'status': 'On Duty', 'patients': 12, 'shift': 'Morning', 'exp': '15 yrs', 'avatar': 'AS', 'color': const Color(0xFF2C6BFF)},
    {'name': 'Dr. Priya Mehta', 'dept': 'Gynecology', 'status': 'On Duty', 'patients': 8, 'shift': 'Morning', 'exp': '10 yrs', 'avatar': 'PM', 'color': const Color(0xFFFF2C7D)},
    {'name': 'Dr. Ramesh Singh', 'dept': 'Neurology', 'status': 'Off Duty', 'patients': 0, 'shift': 'Evening', 'exp': '20 yrs', 'avatar': 'RS', 'color': const Color(0xFF6366F1)},
    {'name': 'Dr. Kavya Joseph', 'dept': 'Pediatrics', 'status': 'On Duty', 'patients': 15, 'shift': 'Morning', 'exp': '7 yrs', 'avatar': 'KJ', 'color': const Color(0xFF10B981)},
    {'name': 'Dr. Vijay Rao', 'dept': 'Orthopedics', 'status': 'On Leave', 'patients': 0, 'shift': '-', 'exp': '12 yrs', 'avatar': 'VR', 'color': const Color(0xFFF59E0B)},
  ];

  final List<Map<String, dynamic>> _nurses = [
    {'name': 'Sunita Devi', 'dept': 'ICU', 'status': 'On Duty', 'ward': 'ICU-A', 'shift': 'Morning', 'exp': '8 yrs', 'avatar': 'SD', 'color': const Color(0xFF10B981)},
    {'name': 'Geeta Rani', 'dept': 'Maternity', 'status': 'On Duty', 'ward': 'Ward-B', 'shift': 'Morning', 'exp': '5 yrs', 'avatar': 'GR', 'color': const Color(0xFFFF2C7D)},
    {'name': 'Ravi Shankar', 'dept': 'Emergency', 'status': 'On Duty', 'ward': 'ER-1', 'shift': 'Night', 'exp': '3 yrs', 'avatar': 'RS', 'color': const Color(0xFFEF4444)},
    {'name': 'Meena Kumari', 'dept': 'Cardiology', 'status': 'Off Duty', 'ward': '-', 'shift': 'Evening', 'exp': '10 yrs', 'avatar': 'MK', 'color': const Color(0xFF64748B)},
  ];

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
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStaffList(_doctors, isDoctors: true),
              _buildStaffList(_nurses, isDoctors: false),
            ],
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

  Widget _buildStaffList(List<Map<String, dynamic>> list, {required bool isDoctors}) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final staff = list[index];
        final statusColor = _statusColor(staff['status']);
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
                backgroundColor: (staff['color'] as Color).withOpacity(0.15),
                child: Text(staff['avatar'],
                    style: TextStyle(fontWeight: FontWeight.bold, color: staff['color'] as Color, fontSize: 14)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(staff['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B))),
                    const SizedBox(height: 3),
                    Text('${staff['dept']} • ${staff['exp']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    Text('Shift: ${staff['shift']}',
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
                    child: Text(staff['status'],
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                  ),
                  if (isDoctors && staff['patients'] > 0) ...[
                    const SizedBox(height: 4),
                    Text('${staff['patients']} patients',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
