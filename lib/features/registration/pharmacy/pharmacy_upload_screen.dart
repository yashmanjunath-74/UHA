import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

class PharmacyUploadScreen extends StatefulWidget {
  const PharmacyUploadScreen({super.key});

  @override
  State<PharmacyUploadScreen> createState() => _PharmacyUploadScreenState();
}

class _PharmacyUploadScreenState extends State<PharmacyUploadScreen> {
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
                    // Title
                    Text(
                      'Pharmacy Registration',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Upload your drug license to proceed.",
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
                          // Pharmacy Name
                          CustomTextField(
                            label: 'Pharmacy Name',
                            hint: 'City Pharmacy',
                            prefixIcon: Icons.local_pharmacy_outlined,
                          ),
                          const SizedBox(height: 32),

                          // Document Upload
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.neutral700
                                    : AppColors.neutral300,
                                width: 2,
                                style: BorderStyle
                                    .solid, // Dashed would be better if we had dashed_rect
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.upload_file_rounded,
                                    size: 32,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Upload Drug License',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.neutral900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'PDF, JPG, or PNG (Max 5MB)',
                                  style: AppTextStyles.bodySmall.copyWith(
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
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: 'Submit for Verification',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/registration/verification_pending',
                    (route) => false,
                  );
                },
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
