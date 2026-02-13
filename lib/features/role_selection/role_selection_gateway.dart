import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/role_card.dart';

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
                    const Spacer(flex: 1),
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
                            shape: BoxShape
                                .circle, // Rounded-xl in one mockup, but circle in another. "Unified Role Selection" has rounded-xl. "Role Selection Gateway" has rounded-full.
                            // Implementing "Role Selection Gateway" (second mockup) which has circle icon bg.
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
                            Icons.add_box_rounded,
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
                              fontSize: 28, // Matches text-[28px]
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
                          'Who are you?',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Cards
                    Column(
                      children: [
                        RoleCard(
                          title: 'Patient',
                          subtitle: 'I am seeking care',
                          icon: Icons.person_outline_rounded,
                          onTap: () => Navigator.pushNamed(context, '/login'),
                        ),
                        RoleCard(
                          title: 'Doctor',
                          subtitle: 'I am a provider',
                          icon: Icons
                              .monitor_heart_outlined, // medical_services/stethoscope
                          onTap: () => Navigator.pushNamed(context, '/login'),
                        ),
                        RoleCard(
                          title: 'Partner',
                          subtitle: 'Hospital / Lab Admin',
                          icon: Icons.domain_rounded,
                          onTap: () => Navigator.pushNamed(context, '/login'),
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),

                    // Footer
                    Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'New here? ',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral500,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register Organization',
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
                        // Progress Indicator dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 24,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(5),
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
          ],
        ),
      ),
    );
  }
}
