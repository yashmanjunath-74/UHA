import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class InventoryManagementDashboard extends StatelessWidget {
  const InventoryManagementDashboard({super.key});

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
                        // Search
                        _buildSearchBar(),
                        const SizedBox(height: 24),

                        // AI Insight Card
                        _buildAIInsightCard(),
                        const SizedBox(height: 24),

                        // Stock Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Stock Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                              ),
                            ),
                            Text(
                              'View Reports >',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Inventory Items
                        _buildInventoryItem(
                          'Paracetamol 500mg',
                          '#8829',
                          'Exp: Dec 2024',
                          '850',
                          'Units',
                          0.8,
                          AppColors.primary,
                          Icons.local_pharmacy,
                          const Color(0xFFE0F2F1),
                          const Color(0xFF009669),
                        ),
                        const SizedBox(height: 16),
                        _buildInventoryItem(
                          'Amoxicillin',
                          '#9921',
                          'Exp: Nov 2024',
                          '120',
                          'Units',
                          0.3,
                          Colors.orange,
                          Icons.vaccines,
                          const Color(0xFFFFF3E0),
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        _buildInventoryItem(
                          'Insulin Glargine',
                          '#1102',
                          'Exp: Jan 2025',
                          '15',
                          'Low Stock',
                          0.1,
                          const Color(0xFFEF4444),
                          Icons.warning_amber_rounded,
                          const Color(0xFFFEE2E2),
                          const Color(0xFFEF4444),
                          isAlert: true,
                        ),
                        const SizedBox(height: 16),
                        _buildInventoryItem(
                          'Bandages (Sterile)',
                          '#4021',
                          'Exp: N/A',
                          '2,400',
                          'Units',
                          0.9,
                          AppColors.primary,
                          Icons.medical_services,
                          const Color(0xFFE3F2FD),
                          const Color(0xFF2196F3),
                        ),
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Floating Reorder Button
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399), // Bright accent green
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF34D399).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: AppColors.neutral900,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Reorder Low Stock (2)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Navigation
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-photo/portrait-smiling-male-doctor_171337-1532.jpg',
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(fontSize: 12, color: AppColors.neutral500),
                  ),
                  const Text(
                    'Dr. Sarah Admin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.notifications_outlined,
            color: AppColors.neutral600,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.neutral400),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search item, batch, or ID...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.neutral400, fontSize: 14),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, color: AppColors.primary, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF9), // Very light emerald
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCCFBF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF34D399)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AI INSIGHT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.close, size: 16, color: AppColors.neutral400),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Predicted Shortage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: AppColors.neutral600,
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'Based on current consumption rates, '),
                TextSpan(
                  text: 'Insulin Glargine',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                TextSpan(text: ' will run out in '),
                TextSpan(
                  text: '3 days',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34D399),
                    foregroundColor: AppColors.neutral900,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reorder Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.neutral200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(color: AppColors.neutral600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(
    String name,
    String id,
    String exp,
    String value,
    String unit,
    double progress,
    Color progressColor,
    IconData icon,
    Color iconBg,
    Color iconColor, {
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isAlert ? Border.all(color: const Color(0xFFFECACA)) : null,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
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
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            id,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.neutral600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•  $exp',
                          style: TextStyle(
                            fontSize: 12,
                            color: isAlert
                                ? const Color(0xFFEF4444)
                                : AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isAlert
                          ? const Color(0xFFEF4444)
                          : AppColors.neutral900,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 12,
                      color: isAlert
                          ? const Color(0xFFEF4444)
                          : AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutral100,
            color: progressColor,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard_rounded, 'Inventory', isActive: true),
          _buildNavItem(Icons.receipt_long_rounded, 'Orders'),
          const SizedBox(width: 40), // Spacer for FAB
          _buildNavItem(Icons.analytics_rounded, 'Reports'),
          _buildNavItem(Icons.settings, 'Settings'),
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
