import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/core/theme/app_text_styles.dart';

class LabDashboardScreen extends StatefulWidget {
  const LabDashboardScreen({super.key});

  @override
  State<LabDashboardScreen> createState() => _LabDashboardScreenState();
}

class _LabDashboardScreenState extends State<LabDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildTabs(isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRequestList(isDark, 'Pending'),
                  _buildRequestList(isDark, 'Urgent'),
                  _buildRequestList(isDark, 'Processing'),
                  _buildRequestList(isDark, 'Completed'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Manual entry or scan QR
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan Order'),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.science, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apollo Diagnostics',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.neutral900,
                ),
              ),
              Text(
                'Lab Admin Panel',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : AppColors.neutral900,
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=12',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark
            ? AppColors.neutral400
            : AppColors.neutral500,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Urgent'),
          Tab(text: 'Processing'),
          Tab(text: 'Done'),
        ],
      ),
    );
  }

  Widget _buildRequestList(bool isDark, String status) {
    // Mock Data
    final requests = List.generate(5, (index) => index);

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildRequestCard(isDark, status, index);
      },
    );
  }

  Widget _buildRequestCard(bool isDark, String status, int index) {
    final isUrgent = status == 'Urgent';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent
              ? AppColors.error.withOpacity(0.3)
              : (isDark ? AppColors.neutral800 : AppColors.neutral100),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isUrgent ? 'URGENT' : '#REQ-2024-${1000 + index}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isUrgent ? AppColors.error : AppColors.primary,
                  ),
                ),
              ),
              Text(
                '10:30 AM',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isDark
                    ? AppColors.neutral800
                    : AppColors.neutral100,
                child: Text(
                  'JD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.neutral900,
                      ),
                    ),
                    Text(
                      'Ref: Dr. Sarah Smith',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tests Requested',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete Blood Count (CBC), Lipid Profile',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : AppColors.neutral800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View Details
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? AppColors.neutral700
                          : AppColors.neutral300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white : AppColors.neutral700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lab/upload_result');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text(
                    'Upload Result',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
