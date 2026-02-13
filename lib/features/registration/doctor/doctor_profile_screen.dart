import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSpecialty;
  int _yearsOfExperience = 5;

  // Mock data for specialties
  final List<String> _specialties = [
    'Cardiology',
    'Dermatology',
    'General Practice',
    'Neurology',
    'Pediatrics',
    'Psychiatry',
  ];

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
                  const SizedBox(width: 40), // Balance spacing
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
                      'Professional Profile',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Let's verify your credentials to get you started with UHA.",
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
                          // Profile Photo Upload (Mock)
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
                                      style: BorderStyle
                                          .solid, // Should be dashed ideally but solid for now
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo_rounded,
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

                          // Full Name
                          CustomTextField(
                            label: 'Full Name',
                            hint: 'Dr. Jane Doe',
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 20),

                          // Specialization
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'Specialization',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: isDark
                                        ? AppColors.neutral300
                                        : AppColors.neutral700,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.surfaceDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.neutral700
                                        : AppColors.neutral200,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedSpecialty,
                                    hint: Text(
                                      'Select your specialty',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.neutral500
                                            : AppColors.neutral400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.expand_more_rounded,
                                      color: isDark
                                          ? AppColors.neutral400
                                          : AppColors.neutral400,
                                    ),
                                    dropdownColor: isDark
                                        ? AppColors.surfaceDark
                                        : Colors.white,
                                    items: _specialties.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : AppColors.neutral900,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedSpecialty = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // License Number
                          CustomTextField(
                            label: 'Medical License Number',
                            hint: 'MD-12345678',
                            prefixIcon: Icons.badge_outlined,
                            textCapitalization: TextCapitalization.characters,
                          ),
                          const SizedBox(height: 20),

                          // Years of Experience
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'Years of Experience',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: isDark
                                        ? AppColors.neutral300
                                        : AppColors.neutral700,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.surfaceDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.neutral700
                                        : AppColors.neutral200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildCounterButton(
                                      icon: Icons.remove,
                                      onTap: () {
                                        if (_yearsOfExperience > 0) {
                                          setState(() => _yearsOfExperience--);
                                        }
                                      },
                                      isLeft: true,
                                      isDark: isDark,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.symmetric(
                                            vertical: BorderSide(
                                              color: isDark
                                                  ? AppColors.neutral700
                                                  : AppColors.neutral200,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '$_yearsOfExperience',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : AppColors.neutral900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _buildCounterButton(
                                      icon: Icons.add,
                                      onTap: () {
                                        setState(() => _yearsOfExperience++);
                                      },
                                      isLeft: false,
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                  // Navigate to Credentials Screen
                  Navigator.pushNamed(
                    context,
                    '/registration/doctor_credentials',
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

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isLeft,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.horizontal(
        left: isLeft ? const Radius.circular(12) : Radius.zero,
        right: isLeft ? Radius.zero : const Radius.circular(12),
      ),
      child: Container(
        width: 48,
        height: 56, // Match standard input height roughly
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral50,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(12) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Icon(icon, color: AppColors.neutral500, size: 20),
      ),
    );
  }
}
