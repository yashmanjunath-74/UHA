import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RoleSelectionGridScreen extends StatelessWidget {
  const RoleSelectionGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Header
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              Text(
                'Welcome to UHA',
                style: AppTextStyles.displayMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.neutral900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your role to continue',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),

              const SizedBox(height: 48),

              // Grid
              Expanded(
                child: Center(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85, // Adjust for card height
                    children: [
                      _buildGridCard(
                        context,
                        'Patient',
                        'Seeking Care',
                        Icons.person_rounded,
                        '/registration/patient',
                      ),
                      _buildGridCard(
                        context,
                        'Doctor',
                        'Providing Care',
                        Icons.medical_services_rounded,
                        '/registration/doctor_profile',
                      ),
                      _buildGridCard(
                        context,
                        'Hospital',
                        'Admin & Lab',
                        Icons.domain_rounded,
                        '/registration/hospital_admin',
                      ),
                      _buildGridCard(
                        context,
                        'Pharmacy',
                        'Fulfillment',
                        Icons.medication_rounded,
                        '/registration/pharmacy_business',
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'New organization? ',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                      children: [
                        TextSpan(
                          text: 'Register here',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.primary.withOpacity(0.1)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.neutral500
                            : AppColors.neutral400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NEED HELP? CONTACT SUPPORT',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.neutral500
                              : AppColors.neutral400,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.neutral900.withOpacity(0.3) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? Colors.transparent
              : Colors.transparent, // Default transparent
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(16),
        hoverColor: AppColors.primary.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.neutral800 : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
