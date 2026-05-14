import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'doctor_home_tab.dart';
import 'doctor_patients_tab.dart';
import '../roster/doctor_roster_management.dart';
import 'doctor_profile_tab.dart';

class DoctorDashboardShell extends ConsumerStatefulWidget {
  const DoctorDashboardShell({super.key});

  @override
  ConsumerState<DoctorDashboardShell> createState() => _DoctorDashboardShellState();
}

class _DoctorDashboardShellState extends ConsumerState<DoctorDashboardShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DoctorHomeTab(),
    DoctorPatientsTab(),
    DoctorRosterManagement(),
    DoctorProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildFloatingNav(),
    );
  }

  Widget _buildFloatingNav() {
    return SafeArea(
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(0, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Home'),
            _navItem(1, Icons.people_alt_rounded, Icons.people_alt_outlined, 'Patients'),
            _navItem(2, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Roster'),
            _navItem(3, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF10B981) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? Colors.white : const Color(0xFF94A3B8),
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}
