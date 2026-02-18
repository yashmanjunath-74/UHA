import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RoleSelectionGatewayScreen extends StatelessWidget {
  const RoleSelectionGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Use Container with gradient for background to match mockup
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5F8F7), // background-light from mockup
                    Color(0xFFE8F5F1), // to-[#E8F5F1]
                  ],
                ),
          color: isDark ? AppColors.backgroundDark : null,
        ),
        child: Stack(
          children: [
            // Background Gradients/Blobs (Softened)
            Positioned(
              top: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(isDark ? 0.05 : 0.03),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceDark
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.displayMedium.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.neutral900,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                            children: const [
                              TextSpan(text: 'Welcome to '),
                              TextSpan(
                                text: 'UHA',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select your role to continue',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Grid
                    Expanded(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                        children: [
                          _buildGridCard(
                            context,
                            'Patient',
                            'Seeking Care',
                            Icons.person_outline_rounded,
                            () => Navigator.pushNamed(
                              context,
                              '/registration/patient',
                            ),
                          ),
                          _buildGridCard(
                            context,
                            'Doctor',
                            'Providing Care',
                            Icons.medical_services_outlined,
                            () => Navigator.pushNamed(
                              context,
                              '/registration/doctor_profile',
                            ),
                          ),
                          _buildGridCard(
                            context,
                            'Hospital',
                            'Healthcare Admin',
                            Icons.domain_rounded,
                            () => Navigator.pushNamed(
                              context,
                              '/registration/hospital_profile',
                            ),
                          ),
                          _buildGridCard(
                            context,
                            'Pharmacy',
                            'Fulfillment',
                            Icons.local_pharmacy_outlined,
                            () => Navigator.pushNamed(
                              context,
                              '/registration/pharmacy_upload',
                            ),
                          ),
                          _buildGridCard(
                            context,
                            'Lab',
                            'Diagnostics',
                            Icons.science_outlined,
                            () => Navigator.pushNamed(
                              context,
                              '/registration/lab_profile',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'New organization? ',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral500,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register here',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                // recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
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
                        // iOS Home Indicator Spacer
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF0F231D) : Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.neutral800 : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // Shadow for light mode
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
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
