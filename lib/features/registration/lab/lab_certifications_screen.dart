import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/primary_button.dart';

class LabCertificationsScreen extends StatefulWidget {
  const LabCertificationsScreen({super.key});

  @override
  State<LabCertificationsScreen> createState() =>
      _LabCertificationsScreenState();
}

class _LabCertificationsScreenState extends State<LabCertificationsScreen> {
  bool _isNABL = false;
  bool _isISO = false;

  // Services
  bool _hasPathology = true;
  bool _hasRadiology = false;
  bool _hasMicrobiology = false;
  bool _hasBiochemistry = true;

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
                      'Certifications',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Verify your accreditations and services offered.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Accreditations Section
                    Text(
                      'Accreditations',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildToggleRow(
                      context,
                      title: 'NABL Accredited',
                      subtitle:
                          'National Accreditation Board for Testing and Calibration Laboratories',
                      value: _isNABL,
                      onChanged: (val) => setState(() => _isNABL = val),
                    ),
                    const SizedBox(height: 16),
                    _buildToggleRow(
                      context,
                      title: 'ISO Certified',
                      subtitle:
                          'International Organization for Standardization',
                      value: _isISO,
                      onChanged: (val) => setState(() => _isISO = val),
                    ),

                    const SizedBox(height: 32),
                    Divider(
                      color: isDark
                          ? AppColors.neutral800
                          : AppColors.neutral200,
                    ),
                    const SizedBox(height: 24),

                    // Services Section
                    Text(
                      'Services Offered',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCheckboxRow(
                      context,
                      'Pathology',
                      _hasPathology,
                      (v) => setState(() => _hasPathology = v!),
                    ),
                    _buildCheckboxRow(
                      context,
                      'Radiology (X-Ray, CT, MRI)',
                      _hasRadiology,
                      (v) => setState(() => _hasRadiology = v!),
                    ),
                    _buildCheckboxRow(
                      context,
                      'Microbiology',
                      _hasMicrobiology,
                      (v) => setState(() => _hasMicrobiology = v!),
                    ),
                    _buildCheckboxRow(
                      context,
                      'Biochemistry',
                      _hasBiochemistry,
                      (v) => setState(() => _hasBiochemistry = v!),
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
                  Navigator.pushNamed(context, '/registration/lab_admin');
                },
                icon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.neutral900,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(
    BuildContext context,
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? AppColors.primary
                : (isDark ? AppColors.neutral700 : AppColors.neutral200),
          ),
        ),
        child: CheckboxListTile(
          value: value,
          onChanged: onChanged,
          title: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.neutral900,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
