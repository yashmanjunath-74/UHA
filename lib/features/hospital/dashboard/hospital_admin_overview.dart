import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class HospitalAdminOverview extends StatelessWidget {
  const HospitalAdminOverview({super.key});

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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // Greeting
                        const Text(
                          'Good morning,',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.neutral600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Dr. Sarah Jenning',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats Horizontal Scroll
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            children: [
                              _buildPatientStatCard(),
                              const SizedBox(width: 16),
                              _buildActiveStaffCard(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Bed Occupancy
                        _buildBedOccupancyCard(),
                        const SizedBox(height: 24),

                        // Financial Overview
                        _buildFinancialOverviewCard(),
                        const SizedBox(height: 24),

                        // Departments
                        const Text(
                          'Departments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDepartmentItem(
                          'Cardiology',
                          '8 Doctors • 24 Patients',
                          Icons.favorite,
                          const Color(0xFFFFEEE8),
                          Color(0xFFFF6B2C),
                        ),
                        const SizedBox(height: 12),
                        _buildDepartmentItem(
                          'Pediatrics',
                          '5 Doctors • 18 Patients',
                          Icons.face,
                          const Color(0xFFE8F1FF),
                          Color(0xFF2C6BFF),
                        ),
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Custom Floating Navigation Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_hospital,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UHA Admin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                "St. Mary's General",
                style: TextStyle(fontSize: 12, color: AppColors.neutral500),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.neutral600,
                  size: 24,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-photo/portrait-smiling-male-doctor_171337-1532.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientStatCard() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.people,
                  color: Color(0xFF2C6BFF),
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppColors.primary,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '12%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Total Patients Today',
            style: TextStyle(fontSize: 12, color: AppColors.neutral500),
          ),
          const SizedBox(height: 8),
          const Text(
            '1,248',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: AppColors.neutral100,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 4,
          ),
          const SizedBox(height: 4),
          const Text(
            '75% of daily capacity',
            style: TextStyle(fontSize: 10, color: AppColors.neutral400),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStaffCard() {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Color(0xFFAF52DE),
              size: 20,
            ),
          ),
          const Spacer(),
          const Text(
            'Active Staff',
            style: TextStyle(fontSize: 12, color: AppColors.neutral500),
          ),
          const SizedBox(height: 8),
          const Text(
            '42',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: Stack(
              children: [
                _buildAvatar(
                  0,
                  'https://img.freepik.com/free-photo/portrait-expressive-young-woman_1258-48167.jpg',
                ),
                _buildAvatar(
                  24,
                  'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg',
                ),
                _buildAvatar(
                  48,
                  'https://img.freepik.com/free-photo/handsome-young-man-with-arms-crossed-white-background_23-2148222620.jpg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(url)),
      ),
    );
  }

  Widget _buildBedOccupancyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bed Occupancy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
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
                          const Text(
                            '75%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                          ),
                          Text(
                            'OCCUPIED',
                            style: TextStyle(
                              fontSize: 8,
                              color: AppColors.neutral500.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem('General Ward', '145', AppColors.primary),
                    const SizedBox(height: 12),
                    _buildLegendItem('ICU', '32', const Color(0xFF66CBA9)),
                    const SizedBox(height: 12),
                    _buildLegendItem('Available', '58', AppColors.neutral200),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.neutral600),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Financial Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'Week',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: const Text(
                        'Month',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Revenue vs Expenses',
            style: TextStyle(fontSize: 12, color: AppColors.neutral500),
          ),
          const SizedBox(height: 24),
          // Chart Placeholder
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar(0.4, 0.3),
                _buildChartBar(0.6, 0.4),
                _buildChartBar(0.5, 0.35),
                _buildChartBar(0.8, 0.45), // Highlight
                _buildChartBar(0.65, 0.4),
                _buildChartBar(0.55, 0.3),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend('Revenue', AppColors.primary),
              const SizedBox(width: 24),
              _buildChartLegend('Expenses', AppColors.primaryLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double revHeight, double expHeight) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Using Containers to simulate bars instead of lines for simplicity
            // or simple rounded bars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 6,
                  height: 100 * revHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 100 * expHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight, // Using light as expenses
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
        ),
      ],
    );
  }

  Widget _buildDepartmentItem(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.neutral400,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.grid_view_rounded, 'Overview', isActive: true),
          _buildNavItem(Icons.people_alt_outlined, 'Patients'),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          _buildNavItem(Icons.medical_services_outlined, 'Staff'),
          _buildNavItem(Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.neutral400,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.primary : AppColors.neutral400,
          ),
        ),
      ],
    );
  }
}
