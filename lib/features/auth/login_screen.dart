import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'package:flutter/gestures.dart';

class UniversalLoginScreen extends StatelessWidget {
  const UniversalLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Login screen mockup has background-light which is now F0FDF4 (Emerald 50)
      // Some mockups show gradients. "Universal Login Screen" has bg-background-light.
      // We will use a subtle gradient to match the premium feel if not explicitly solid in that specific mockup,
      // but the mockup says "bg-background-light".
      // However, "Role Selection" used a gradient. Let's use the backgroundGradient defined in AppColors for consistency
      // or just the backgroundLight color as per Tailwind config.
      // Tailwind config: "background-light": "#F0FDF4"
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Background Glows (Updated positions/colors from mockup)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.primaryLight.withOpacity(
                                    0.5,
                                  ), // bg-primary/10
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // rounded-2xl
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF009366,
                                ).withOpacity(0.15), // shadow-soft
                                blurRadius: 40,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_hospital_rounded,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'UHA',
                              style: AppTextStyles.displayLarge.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF111827), // gray-900
                                fontSize: 30, // text-3xl
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.lock_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // mb-2 is small, keeping 8
                        Text(
                          'Universal Health Application',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500, // gray-500
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1F2937)
                            : Colors.white, // card-light/dark
                        borderRadius: BorderRadius.circular(
                          32,
                        ), // rounded-[2rem]
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFF3F4F6), // border-gray-100
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05), // shadow-xl
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: isDark
                                  ? const Color(0xFFF3F4F6)
                                  : const Color(0xFF1F2937), // gray-800
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // text-xl
                            ),
                          ),
                          const SizedBox(height: 24),

                          const CustomTextField(
                            label: 'Email or UHID Number',
                            hint: 'Enter your ID or email',
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 20), // space-y-5
                          const CustomTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: true,
                            suffixIcon: Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.neutral400,
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8), // padding fix
                          PrimaryButton(
                            text: 'Secure Login',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: () {
                              // Login Logic
                            },
                          ),

                          const SizedBox(height: 32), // relative my-8

                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: isDark
                                      ? AppColors.neutral700
                                      : AppColors.neutral200,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1F2937)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Or continue with',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.neutral400
                                          : AppColors.neutral500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: isDark
                                      ? AppColors.neutral700
                                      : AppColors.neutral200,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? const Color(0xFF1F2937)
                                  : Colors.white,
                              foregroundColor: isDark
                                  ? const Color(0xFFE5E7EB)
                                  : const Color(0xFF374151), // text-gray-700
                              elevation: 0,
                              side: BorderSide(
                                color: isDark
                                    ? const Color(0xFF374151)
                                    : const Color(0xFFE5E7EB),
                              ), // border-gray-200
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAiMXc7Sq89XMsmKrNhnrsClcwxplk5T0VkK8TUi3uhAbPWE5CWec7j7AzTY8la3xFIeUHxLiI2iHSH1EI9hyCAleIgk-WPZ_aGA1ngpKskqHpVdDRZsW9RXB14RbBznJaRHKzez7kcC3tJyoe0PkqaijgIDwnwo8AQV6AqM6tak7zMJR-BGUlU2N4qcZTuf7YKBwh-r3NgJ4j-8W_Yjhwucn3uu-5zVLefliK7ZFqWka3CJBI3QQBUSGKVin22C5kFgIvYuzgMZS0y',
                                  height: 20,
                                  width: 20,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.g_mobiledata,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Continue with Google',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32), // mt-8

                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  '/registration/basic',
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
