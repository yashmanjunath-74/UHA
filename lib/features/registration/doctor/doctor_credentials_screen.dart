import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

class DoctorCredentialsScreen extends StatefulWidget {
  const DoctorCredentialsScreen({super.key});

  @override
  State<DoctorCredentialsScreen> createState() =>
      _DoctorCredentialsScreenState();
}

class _DoctorCredentialsScreenState extends State<DoctorCredentialsScreen> {
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
                    // Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Step 2 of 3',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '66% Completed',
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
                        value: 0.66,
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
                      'Credentials & Clinic',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.neutral900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Details about your practice and affiliation.",
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
                          // Hospital/Clinic Name
                          CustomTextField(
                            label: 'Hospital / Clinic Name',
                            hint: 'City General Hospital',
                            prefixIcon: Icons.local_hospital_outlined,
                          ),
                          const SizedBox(height: 20),

                          // Clinic Address
                          CustomTextField(
                            label: 'Clinic Address',
                            hint: '123 Medical Center Dr.',
                            prefixIcon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 20),

                          // Work Phone Number
                          CustomTextField(
                            label: 'Work Phone Number',
                            hint: '+1 (555) 000-0000',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 32),

                          // Document Upload
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.neutral700
                                    : AppColors.neutral300,
                                style: BorderStyle
                                    .none, // Using CustomPainter for dashed would be better
                              ),
                            ),
                            child: CustomPaint(
                              painter: _DashedBorderPainter(
                                color: isDark
                                    ? AppColors.neutral600
                                    : AppColors.neutral300,
                                strokeWidth: 2,
                                gap: 6,
                              ),
                              child: Container(
                                // Content inside dashed border
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.upload_file_rounded,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Upload Medical ID / Proof',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.neutral900,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'PDF, JPG or PNG (Max 5MB)',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.neutral400
                                            : AppColors.neutral500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                text: 'Next Step',
                onPressed: () {
                  Navigator.pushNamed(context, '/registration/doctor_security');
                },
                icon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16), // Match container radius
      ),
    );

    Path dashPath = Path();
    double dashWidth = 10.0;
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
