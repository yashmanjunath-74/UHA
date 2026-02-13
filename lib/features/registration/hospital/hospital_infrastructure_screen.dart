import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/primary_button.dart';

class HospitalInfrastructureScreen extends StatefulWidget {
  const HospitalInfrastructureScreen({super.key});

  @override
  State<HospitalInfrastructureScreen> createState() =>
      _HospitalInfrastructureScreenState();
}

class _HospitalInfrastructureScreenState
    extends State<HospitalInfrastructureScreen> {
  int _bedCapacity = 50;
  int _departments = 5;
  bool _hasEmergency = true;
  bool _hasAmbulance = true;
  bool _hasICU = true;

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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDark ? Colors.white : AppColors.neutral600,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Registration',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Step 2 of 3',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '66% Completed',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.66,
                        backgroundColor: isDark
                            ? AppColors.surfaceDark
                            : AppColors.neutral200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Infrastructure',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Details about capacity and available facilities.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bed Capacity
                    _buildCounterRow(
                      context,
                      title: 'Total Bed Capacity',
                      value: _bedCapacity,
                      onChanged: (val) => setState(() => _bedCapacity = val),
                    ),
                    const SizedBox(height: 24),

                    // Departments
                    _buildCounterRow(
                      context,
                      title: 'Number of Departments',
                      value: _departments,
                      onChanged: (val) => setState(() => _departments = val),
                    ),
                    const SizedBox(height: 32),

                    Divider(
                      color: isDark
                          ? AppColors.neutral800
                          : AppColors.neutral200,
                    ),
                    const SizedBox(height: 24),

                    // Services Toggles
                    _buildToggleRow(
                      context,
                      title: 'Emergency Services (24/7)',
                      icon: Icons.emergency_rounded,
                      value: _hasEmergency,
                      onChanged: (val) => setState(() => _hasEmergency = val),
                    ),
                    const SizedBox(height: 16),
                    _buildToggleRow(
                      context,
                      title: 'Ambulance Service',
                      icon: Icons.directions_car_filled_rounded,
                      value: _hasAmbulance,
                      onChanged: (val) => setState(() => _hasAmbulance = val),
                    ),
                    const SizedBox(height: 16),
                    _buildToggleRow(
                      context,
                      title: 'ICU / Critical Care',
                      icon: Icons.monitor_heart_rounded,
                      value: _hasICU,
                      onChanged: (val) => setState(() => _hasICU = val),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: 'Next Step',
                onPressed: () {
                  Navigator.pushNamed(context, '/registration/hospital_admin');
                },
                icon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow(
    BuildContext context, {
    required String title,
    required int value,
    required Function(int) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: isDark ? AppColors.neutral300 : AppColors.neutral700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildIconButton(
                context,
                icon: Icons.remove,
                onTap: () {
                  if (value > 0) onChanged(value - 1);
                },
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral900,
                  ),
                ),
              ),
              _buildIconButton(
                context,
                icon: Icons.add,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.neutral500, size: 24),
      ),
    );
  }

  Widget _buildToggleRow(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.neutral900,
                fontSize: 15,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
