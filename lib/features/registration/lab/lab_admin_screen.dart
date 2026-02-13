import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

class LabAdminScreen extends StatefulWidget {
  const LabAdminScreen({super.key});

  @override
  State<LabAdminScreen> createState() => _LabAdminScreenState();
}

class _LabAdminScreenState extends State<LabAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

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
                          'Step 3 of 3',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '100% Completed',
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
                        value: 1.0,
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
                      'Admin & Bank Details',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Setup admin access and payout details.",
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
                          // Administrator Name
                          CustomTextField(
                            label: 'Administrator Name',
                            hint: 'Full Name',
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 20),

                          // Email
                          CustomTextField(
                            label: 'Admin Email',
                            hint: 'admin@lab.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Password
                          CustomTextField(
                            label: 'Password',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: isDark
                                    ? AppColors.neutral500
                                    : AppColors.neutral400,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 32),
                          Divider(
                            color: isDark
                                ? AppColors.neutral800
                                : AppColors.neutral200,
                          ),
                          const SizedBox(height: 24),

                          // Bank Details Header
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Bank Details',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.neutral900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Bank Name
                          CustomTextField(
                            label: 'Bank Name',
                            hint: 'Example Bank Ltd.',
                            prefixIcon: Icons.account_balance_rounded,
                          ),
                          const SizedBox(height: 20),

                          // Account Number
                          CustomTextField(
                            label: 'Account Number',
                            hint: '123456789012',
                            prefixIcon: Icons.credit_card_rounded,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),

                          // IFSC Code
                          CustomTextField(
                            label: 'IFSC Code',
                            hint: 'EXBK0001234',
                            prefixIcon: Icons.qr_code_rounded,
                            textCapitalization: TextCapitalization.characters,
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
                text: 'Complete Registration',
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
