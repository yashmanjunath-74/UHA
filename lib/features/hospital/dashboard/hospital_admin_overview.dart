import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'hospital_patients_screen.dart';
import 'hospital_staff_screen.dart';
import 'hospital_settings_screen.dart';

class HospitalAdminOverview extends StatefulWidget {
  const HospitalAdminOverview({super.key});

  @override
  State<HospitalAdminOverview> createState() => _HospitalAdminOverviewState();
}

class _HospitalAdminOverviewState extends State<HospitalAdminOverview> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _OverviewTab(),
    HospitalPatientsScreen(),
    HospitalStaffScreen(),
    HospitalSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(child: _screens[_currentIndex]),
              ],
            ),
            // Floating Bottom Navigation Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final titles = ['Overview', 'Patients', 'Staff', 'Settings'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_hospital, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[_currentIndex],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neutral900),
              ),
              const Text("St. Mary's General Hospital", style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.notifications_outlined, color: AppColors.neutral600, size: 22),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3B30),
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1.5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.grid_view_rounded, Icons.grid_view_rounded, 'Overview'),
          _navItem(1, Icons.people_alt_rounded, Icons.people_alt_outlined, 'Patients'),
          _navItem(2, Icons.medical_services_rounded, Icons.medical_services_outlined, 'Staff'),
          _navItem(3, Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? Colors.white : const Color(0xFF94A3B8),
              size: 20,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Overview Tab (the original dashboard content)
/// ─────────────────────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text('Good morning,', style: TextStyle(fontSize: 14, color: AppColors.neutral600)),
          const SizedBox(height: 4),
          const Text('Hospital Admin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          const SizedBox(height: 24),

          // Stats Horizontal Scroll
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: const [
                _PatientStatCard(),
                SizedBox(width: 16),
                _ActiveStaffCard(),
                SizedBox(width: 16),
                _EmergencyCard(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildQuickAction(Icons.bed_rounded, 'Bed\nStatus', const Color(0xFF2C6BFF)),
              const SizedBox(width: 12),
              _buildQuickAction(Icons.assignment_outlined, 'Reports', const Color(0xFF10B981)),
              const SizedBox(width: 12),
              _buildQuickAction(Icons.local_pharmacy_outlined, 'Pharmacy', const Color(0xFF6366F1)),
              const SizedBox(width: 12),
              _buildQuickAction(Icons.science_outlined, 'Lab', const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 24),

          // Bed Occupancy
          _buildBedOccupancyCard(),
          const SizedBox(height: 24),

          // Financial Overview
          _buildFinancialCard(),
          const SizedBox(height: 24),

          // Departments
          const Text('Active Departments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          const SizedBox(height: 16),
          _buildDeptItem('Cardiology', '8 Doctors • 24 Patients', Icons.favorite_rounded, const Color(0xFFFFEEE8), const Color(0xFFFF6B2C)),
          const SizedBox(height: 10),
          _buildDeptItem('Pediatrics', '5 Doctors • 18 Patients', Icons.face_rounded, const Color(0xFFE8F1FF), const Color(0xFF2C6BFF)),
          const SizedBox(height: 10),
          _buildDeptItem('Orthopedics', '4 Doctors • 12 Patients', Icons.accessibility_new_rounded, const Color(0xFFF3E8FF), const Color(0xFFAF52DE)),
          const SizedBox(height: 10),
          _buildDeptItem('Emergency', '6 Doctors • 9 Patients', Icons.emergency_rounded, const Color(0xFFFFE8E8), const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBedOccupancyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bed Occupancy', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
              Text('Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    const CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 10,
                      backgroundColor: AppColors.neutral100,
                      color: AppColors.primary,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('75%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
                          Text('OCCUPIED', style: TextStyle(fontSize: 8, color: AppColors.neutral500.withOpacity(0.8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: const [
                    _LegendItem('General Ward', '145', AppColors.primary),
                    SizedBox(height: 10),
                    _LegendItem('ICU', '32', Color(0xFF6366F1)),
                    SizedBox(height: 10),
                    _LegendItem('Available', '58', Color(0xFFE2E8F0)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Financial Overview', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          const SizedBox(height: 4),
          const Text('Revenue vs Expenses', style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              _BarPair(0.4, 0.3),
              _BarPair(0.6, 0.4),
              _BarPair(0.5, 0.35),
              _BarPair(0.8, 0.45),
              _BarPair(0.65, 0.4),
              _BarPair(0.55, 0.3),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendBadge('Revenue', AppColors.primary),
              const SizedBox(width: 20),
              _buildLegendBadge('Expenses', const Color(0xFFE2E8F0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBadge(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
      ],
    );
  }

  Widget _buildDeptItem(String title, String sub, IconData icon, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: fg, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.neutral900)),
                Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.neutral400),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label, value;
  final Color color;
  const _LegendItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.neutral600)),
        ]),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
      ],
    );
  }
}

class _BarPair extends StatelessWidget {
  final double rev, exp;
  const _BarPair(this.rev, this.exp);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 7, height: 120 * rev, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 4),
                Container(width: 7, height: 120 * exp, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat cards ────────────────────────────────────────────────────────────────
class _PatientStatCard extends StatelessWidget {
  const _PatientStatCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFE8F1FF), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.people, color: Color(0xFF2C6BFF), size: 20)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
                child: const Row(children: [
                  Icon(Icons.arrow_upward, color: AppColors.primary, size: 12),
                  SizedBox(width: 4),
                  Text('12%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ]),
              ),
            ],
          ),
          const Spacer(),
          const Text('Total Patients Today', style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
          const SizedBox(height: 4),
          const Text('1,248', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: 0.75, backgroundColor: AppColors.neutral100, color: AppColors.primary, borderRadius: BorderRadius.circular(4), minHeight: 4),
          const SizedBox(height: 4),
          const Text('75% of daily capacity', style: TextStyle(fontSize: 10, color: AppColors.neutral400)),
        ],
      ),
    );
  }
}

class _ActiveStaffCard extends StatelessWidget {
  const _ActiveStaffCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.medical_services, color: Color(0xFFAF52DE), size: 20)),
          const Spacer(),
          const Text('Active Staff', style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
          const SizedBox(height: 4),
          const Text('42', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          const SizedBox(height: 8),
          Row(children: [
            CircleAvatar(radius: 11, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=3')),
            const SizedBox(width: 4),
            CircleAvatar(radius: 11, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=5')),
            const SizedBox(width: 4),
            CircleAvatar(radius: 11, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=7')),
          ]),
        ],
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 20)),
          const Spacer(),
          const Text('Emergency', style: TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 4),
          const Text('12', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: const Text('3 Critical', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
