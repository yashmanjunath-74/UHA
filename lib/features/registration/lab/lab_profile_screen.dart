import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

class LabProfileScreen extends StatefulWidget {
  const LabProfileScreen({super.key});

  @override
  State<LabProfileScreen> createState() => _LabProfileScreenState();
}

class _LabProfileScreenState extends State<LabProfileScreen> {
  final _formKey = GlobalKey<FormState>();

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
                          'Step 1 of 3',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '33% Completed',
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
                        value: 0.33,
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
                      'Facility Details',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Basic information about your diagnostic center.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Lab Logo Upload
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.surfaceDark
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.neutral700
                                          : AppColors.neutral300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.biotech_rounded,
                                    size: 32,
                                    color: isDark
                                        ? AppColors.neutral400
                                        : AppColors.neutral400,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Lab Name
                          CustomTextField(
                            label: 'Lab / Diagnostic Center Name',
                            hint: 'City Diagnostics',
                            prefixIcon: Icons.science_outlined,
                          ),
                          const SizedBox(height: 20),

                          // License Number
                          CustomTextField(
                            label: 'License Number',
                            hint: 'LAB-12345678',
                            prefixIcon: Icons.badge_outlined,
                            textCapitalization: TextCapitalization.characters,
                          ),
                          const SizedBox(height: 20),

                          // Address
                          CustomTextField(
                            label: 'Facility Address',
                            hint: '123 Health Street',
                            prefixIcon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 20),

                          // Contact Number
                          CustomTextField(
                            label: 'Contact Number',
                            hint: '+1 (555) 000-0000',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
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
                  Navigator.pushNamed(
                    context,
                    '/registration/lab_certifications',
                  );
                },
                icon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
