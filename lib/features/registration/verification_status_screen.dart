import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Illustration / Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded, // or pending_actions
                  color: AppColors.primary,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Verification Under Review',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.neutral900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Thank you for registering with UHA. Your profile is currently under review by our administration team. We will notify you once your account is satisfied.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              PrimaryButton(
                text: 'Return to Home',
                onPressed: () {
                  // Navigate back to role selection or login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
