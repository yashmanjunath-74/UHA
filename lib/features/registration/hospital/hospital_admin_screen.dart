import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/common/custom_text_field.dart';
import '../../../core/common/primary_button.dart';
import 'hospital_registration_provider.dart';

class HospitalAdminScreen extends ConsumerStatefulWidget {
  const HospitalAdminScreen({super.key});

  @override
  ConsumerState<HospitalAdminScreen> createState() => _HospitalAdminScreenState();
}

class _HospitalAdminScreenState extends ConsumerState<HospitalAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _adminNameController.dispose();
    _adminEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red));
        return;
      }
      
      ref.read(hospitalRegProvider.notifier).updateAdmin(
        adminName: _adminNameController.text.trim(),
        adminEmail: _adminEmailController.text.trim(),
        password: _passwordController.text,
      );

      await ref.read(hospitalRegProvider.notifier).submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(hospitalRegProvider);

    ref.listen(hospitalRegProvider, (previous, next) {
      if (next.error != null && (previous?.error != next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!), backgroundColor: Colors.red));
      } else if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        Routemaster.of(context).replace(AppConstants.routeWaitingApproval);
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
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
                      decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : Colors.grey[100], shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.neutral600, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Text('Registration', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.neutral400 : AppColors.neutral500, fontWeight: FontWeight.w500)),
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
                        const Text('Step 3 of 3', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                        Text('100% Completed', style: TextStyle(color: isDark ? AppColors.neutral400 : AppColors.neutral500, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: 1.0, backgroundColor: isDark ? AppColors.surfaceDark : AppColors.neutral200, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 8),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text('Admin Configuration', style: AppTextStyles.displayMedium.copyWith(color: isDark ? Colors.white : AppColors.neutral900, fontSize: 28)),
                    const SizedBox(height: 8),
                    Text("Set up the administrator account for this institution.", style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.neutral400 : AppColors.neutral500)),
                    const SizedBox(height: 32),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(controller: _adminNameController, label: 'Administrator Name', hint: 'Full Name', prefixIcon: Icons.person_outline_rounded, validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 20),

                          CustomTextField(controller: _adminEmailController, label: 'Admin Access ID / Email', hint: 'admin@hospital.com', prefixIcon: Icons.badge_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: isDark ? AppColors.neutral500 : AppColors.neutral400),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscureConfirmPassword,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: isDark ? AppColors.neutral500 : AppColors.neutral400),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
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
                text: 'Complete Registration',
                onPressed: state.isLoading ? () {} : _submit,
                icon: Icons.check_circle_outline_rounded,
                isLoading: state.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
