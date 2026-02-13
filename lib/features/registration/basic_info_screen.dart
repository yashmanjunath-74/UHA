import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_dropdown.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  String? _selectedGender = 'Male'; // Default selection for demo

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // "Patient Registration: Basic Info" mockup has bg-gray-100 (which is #F3F4F6) or in one HTML "bg-background-light"
    // The HTML "Patient Registration: Basic Info" says "bg-gray-100 dark:bg-background-dark".
    // But then inside the phone frame it says "bg-background-light".
    // "background-light" in that specific HTML was "#FFFFFF" (white).
    // So the phone screen itself is white.
    // Wait, the "Verification" screen has background-light as "#FFFFFF".
    // But the user said "current color of UI is different".
    // "Verification" mockup used #FFFFFF, but "Role Selection" used #F5F8F7.
    // I will stick to AppColors.backgroundLight which defines the general theme now (#F0FDF4/F5F8F7).
    // EXCEPT "Basic Info" HTML explicitly set "bg-background-light" inside the phone frame.
    // I will use AppColors.backgroundLight for consistency, which is now tint.

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ), // neutral-900
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.neutral800
                          : Colors.white, // hover:bg-neutral-100 logic
                      // In mockup: "hover:bg-neutral-100". Default usually transparent or white?
                      // The mockup screenshot usually shows white or transparent on these.
                      highlightColor: AppColors.neutral100,
                    ),
                  ),
                  Text(
                    'Basic Information',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance header
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step 1 of 3',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral500,
                        ),
                      ),
                      Text(
                        '33%',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.neutral800
                          : AppColors.neutral100, // bg-neutral-100
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.33,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide your basic information to set up your patient profile.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Photo Upload
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 128, // w-32
                            height: 128, // h-32
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppColors.neutral800
                                  : const Color(0xFFF9FAFB), // neutral-50
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                                // dashed implemented via CustomPainter in other screen, here mockup says border-dashed.
                                // I will use solid here as I didn't port the painter to this file or make it shared yet.
                                // For high fidelity, I should share the painter, but user asked for color mostly.
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_rounded,
                                  color: AppColors.primary,
                                  size: 32,
                                ), // text-3xl = 30px
                                const SizedBox(height: 4),
                                Text(
                                  'Add Photo',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.backgroundDark
                                      : Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ), // shadow-sm
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    const CustomTextField(
                      label: 'Full Name',
                      hint: 'Jane Doe',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextField(
                      label: 'Date of Birth',
                      hint: 'MM/DD/YYYY',
                      prefixIcon: Icons.calendar_today_rounded,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.neutral400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    Text(
                      'Gender',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isDark
                            ? AppColors.neutral300
                            : const Color(0xFF374151), // neutral-700
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption('Male', Icons.male_rounded),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption(
                            'Female',
                            Icons.female_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption(
                            'Other',
                            Icons.transgender_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Phone Number with Country Code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 110,
                          child: CustomDropdown<String>(
                            label: 'Contact',
                            items: const [
                              DropdownMenuItem(
                                value: '+1',
                                child: Text('🇺🇸 +1'),
                              ),
                              DropdownMenuItem(
                                value: '+44',
                                child: Text('🇬🇧 +44'),
                              ),
                              DropdownMenuItem(
                                value: '+91',
                                child: Text('🇮🇳 +91'),
                              ),
                            ],
                            value: '+1',
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: CustomTextField(
                            label: '',
                            hint: '(555) 000-0000',
                            keyboardType: TextInputType.phone,
                            prefixIcon: null,
                            suffixIcon: Icon(
                              Icons.phone_iphone_rounded,
                              color: AppColors.neutral400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer Button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight, // bg-background-light
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  ),
                ),
              ),
              child: PrimaryButton(
                text: 'Next Step',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, '/registration/verification');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, IconData icon) {
    final isSelected = _selectedGender == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          // bg-primary-light (E0F5EF) when selected.
          // In AppColors, primaryLight is E0F2F1.
          color: isSelected
              ? (isDark
                    ? AppColors.primary.withOpacity(0.2)
                    : const Color(0xFFE0F5EF))
              : (isDark ? AppColors.neutral800 : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.neutral700 : AppColors.neutral200),
          ),
          boxShadow: isSelected
              ? [
                  // shadow-sm
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.neutral400
                              : AppColors.neutral500),
                    size: 24, // text-[20px]
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500),
                      // Text color in active state wasn't explicitly text-primary in mockup structure, but had an absolute rounded-full bg-primary dot.
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 12, // text-xs
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0, // right-2 top-2 in mockup
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
