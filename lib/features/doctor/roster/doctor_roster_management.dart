import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class DoctorRosterManagement extends StatelessWidget {
  const DoctorRosterManagement({super.key});

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
                        // Month Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                color: AppColors.neutral500,
                              ),
                              onPressed: () {},
                            ),
                            const Text(
                              'October 2023',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                color: AppColors.neutral500,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Date Strip
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            children: [
                              _buildDateItem('Mon', '12'),
                              const SizedBox(width: 12),
                              _buildDateItem('Tue', '13'),
                              const SizedBox(width: 12),
                              _buildDateItem('Wed', '14', isActive: true),
                              const SizedBox(width: 12),
                              _buildDateItem('Thu', '15'),
                              const SizedBox(width: 12),
                              _buildDateItem('Fri', '16'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Legend
                        Row(
                          children: [
                            _buildLegendDot(AppColors.primary, 'On Duty'),
                            const SizedBox(width: 16),
                            _buildLegendDot(
                              const Color(0xFFFF9F43),
                              'In Surgery',
                            ),
                            const SizedBox(width: 16),
                            _buildLegendDot(AppColors.neutral400, 'On Leave'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Shifts
                        _buildShiftSection(
                          'Morning Shift',
                          '08:00 - 16:00',
                          Icons.wb_sunny_rounded,
                          const Color(0xFFFFF9C4),
                          Colors.orange,
                          [
                            _buildDoctorCard(
                              'Dr. Alan Grant',
                              'Cardiology',
                              'ON DUTY',
                              Colors.white,
                              const Color(0xFFCCFBF1),
                              AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            _buildDoctorCard(
                              'Dr. Ellie Sattler',
                              'Pediatrics',
                              'SURGERY',
                              Colors.white,
                              const Color(0xFFFFEAD0),
                              const Color(0xFFFF9F43),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildShiftSection(
                          'Evening Shift',
                          '16:00 - 00:00',
                          Icons.nights_stay_rounded,
                          const Color(0xFFE8EAF6),
                          const Color(0xFF3F51B5),
                          [
                            _buildDoctorCard(
                              'Dr. Ian Malcolm',
                              'Neurology',
                              'ON DUTY',
                              Colors.white,
                              const Color(0xFFCCFBF1),
                              AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            _buildAssignDoctorPlaceholder(),
                          ],
                        ),
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Floating Action Button
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 32,
                          child: Stack(
                            children: [
                              _buildMiniAvatar(
                                0,
                                'https://img.freepik.com/free-photo/portrait-expressive-young-woman_1258-48167.jpg',
                              ),
                              _buildMiniAvatar(
                                20,
                                'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg',
                              ),
                              Positioned(
                                left: 40,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: AppColors.neutral200,
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(
                                      BorderSide(color: Colors.white, width: 2),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+2',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.neutral600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '3 Staff assigned',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 24,
                  left: 32,
                  right: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavIcon(Icons.grid_view, 'Home'),
                    _buildNavIcon(
                      Icons.calendar_today_rounded,
                      'Roster',
                      isActive: true,
                    ),
                    const SizedBox(width: 48), // Space for FAB
                    _buildNavIcon(Icons.people_alt_outlined, 'Staff'),
                    _buildNavIcon(Icons.settings_outlined, 'Settings'),
                  ],
                ),
              ),
            ),
            // Centered FAB
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Roster Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage shifts & staff',
                style: TextStyle(fontSize: 14, color: AppColors.neutral500),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.filter_list, color: AppColors.neutral900),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, {bool isActive = false}) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? Colors.white.withOpacity(0.8)
                  : AppColors.neutral500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : AppColors.neutral900,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
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
          style: const TextStyle(fontSize: 12, color: AppColors.neutral600),
        ),
      ],
    );
  }

  Widget _buildShiftSection(
    String title,
    String time,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
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
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.add, color: AppColors.primary),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildDoctorCard(
    String name,
    String specialty,
    String status,
    Color bgColor,
    Color statusBgColor,
    Color statusTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://img.freepik.com/free-photo/doctor-offering-medical-advice_23-2148766159.jpg',
                ), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusTextColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert, color: AppColors.neutral400, size: 20),
        ],
      ),
    );
  }

  Widget _buildAssignDoctorPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutral200,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Needs one more staff',
            style: TextStyle(fontSize: 14, color: AppColors.neutral500),
          ),
          const SizedBox(height: 8),
          Text(
            'Assign Doctor',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, {bool isActive = false}) {
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

  Widget _buildMiniAvatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
