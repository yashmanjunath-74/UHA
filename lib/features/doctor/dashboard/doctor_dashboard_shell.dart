import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'doctor_home_tab.dart';
import 'doctor_patients_tab.dart';
import '../roster/doctor_roster_management.dart';
import '../prescription/e_rx_pad_screen.dart';
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
    ERxPadScreen(),
    DoctorProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          // Main Content
          _screens[_currentIndex],

          // Floating Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingNav(),
          ),
        ],
      ),

      // FAB add button (centre)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabTap(),
        backgroundColor: const Color(0xFF10B981),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onFabTap() {
    // Depending on current tab, FAB does different things
    if (_currentIndex == 0) {
      // Add new appointment
    } else if (_currentIndex == 3) {
      // Add medication
    }
    setState(() => _currentIndex = 3); // open rx pad
  }

  Widget _buildFloatingNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Home'),
          _navItem(1, Icons.people_alt_rounded, Icons.people_alt_outlined, 'Patients'),
          // Gap for FAB
          const SizedBox(width: 56),
          _navItem(2, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Roster'),
          _navItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
        ],
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
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}
