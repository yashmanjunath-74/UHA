import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lab_home_tab.dart';
import 'lab_tests_tab.dart';
import 'lab_earnings_tab.dart';
import 'lab_profile_tab.dart';
import 'lab_manage_tests_tab.dart';

class LabDashboardShell extends ConsumerStatefulWidget {
  const LabDashboardShell({super.key});

  @override
  ConsumerState<LabDashboardShell> createState() => _LabDashboardShellState();
}

class _LabDashboardShellState extends ConsumerState<LabDashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    LabHomeTab(),
    LabTestsTab(),
    LabManageTestsTab(),
    LabEarningsTab(),
    LabProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildFloatingNav(),
    );
  }

  Widget _buildFloatingNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          _navItem(0, Icons.dashboard_rounded, Icons.dashboard_outlined, 'Home'),
          _navItem(1, Icons.assignment_rounded, Icons.assignment_outlined, 'Orders'),
          _navItem(2, Icons.biotech_rounded, Icons.biotech_outlined, 'Tests'),
          _navItem(3, Icons.payments_rounded, Icons.payments_outlined, 'Earnings'),
          _navItem(4, Icons.person_rounded, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
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
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
