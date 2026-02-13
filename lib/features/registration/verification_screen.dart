import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Verification screen HTML uses "bg-background-light" -> F0FDF4 or FFFFFF?
    // In one place it says "bg-background-light", in another mockup it looks white.
    // The "Patient Registration: Verification" HTML style block says:
    // body { bg-background-light ... text-neutral-800 ... }
    // background-light: #FFFFFF
    // So this screen specifically is WHITE in the mockup provided in Step 124.
    // However, the user said "current color of UI is different" and likely wants consistency or the specific tinted look if they saw it elsewhere.
    // But since the mockup explicitly has #FFFFFF for this screen's background-light variable, I will use Colors.white for light mode
    // OR AppColors.surfaceLight if I mapped it to white.
    // AppColors.backgroundLight is now #F0FDF4.
    // AppColors.surfaceLight is #FFFFFF.
    // So for this screen I should arguably use surfaceLight (White) as the background if following that specific HTML file's look.
    // BUT the outer body has bg-background-light. The MAIN tag has bg-white.
    // So distinct white card on tinted background?
    // The HTML structure is: body(bg-background-light) -> main(bg-white).
    // So yes, it's a white card centered on a tinted background?
    // Actually the body has "flex justify-center". Main is max-w-md.
    // So it IS a white card approach on desktop, but full screen on mobile?
    // "min-h-screen flex flex-col relative overflow-hidden shadow-2xl" on main.
    // If I am building a mobile app, usually we just take the main content bg.
    // I will use Colors.white (surfaceLight) for the Scaffold background to match the "main" tag's white bg in the mockup.

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
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
                      color: isDark ? Colors.white : AppColors.neutral600,
                    ), // neutral-600
                    style: IconButton.styleFrom(
                      // p-2 rounded-full hover:bg-neutral-100
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors
                          .transparent, // default in mockup seems transparent/hover-only
                      foregroundColor: AppColors.neutral600,
                    ),
                  ),
                  Text(
                    'Verification',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 18, // text-lg
                      fontWeight: FontWeight.w600, // font-semibold
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF111827), // neutral-900 (approx)
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step 2 of 3',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral500,
                        ),
                      ),
                      Text(
                        '66%',
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
                          : AppColors.neutral100,
                      borderRadius: BorderRadius.circular(4), // rounded-full
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.66,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(
                                0.3,
                              ), // shadow-sm
                              blurRadius: 2,
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
                      'Identity Verification',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF111827), // neutral-900
                        fontSize: 24, // text-2xl
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide your official identification details to secure your Universal Health account.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.neutral400
                            : const Color(0xFF475569), // neutral-600
                        height: 1.6, // leading-relaxed
                        fontSize: 14, // text-sm
                      ),
                    ),
                    const SizedBox(height: 32),

                    // National ID Input
                    const CustomTextField(
                      label: 'National ID / UHID Number',
                      hint: 'Enter your 12-digit ID',
                      prefixIcon: null,
                      suffixIcon: Icon(
                        Icons.badge_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Found on the front of your government issued ID card.',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12, // text-xs
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Photo Upload Area
                    Text(
                      'Photo of Government ID',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isDark
                            ? AppColors.neutral300
                            : const Color(0xFF334155), // neutral-700
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12), // mb-2

                    Container(
                      width: double.infinity,
                      height: 240, // padding p-8, approx height
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight, // surface-light (#F1F8F1)
                        // Mockup says bg-surface-light (F1F8F1).
                        // I will use that.
                        borderRadius: BorderRadius.circular(16), // rounded-2xl
                      ),
                      child: CustomPaint(
                        painter: DashedBorderPainter(
                          color: AppColors.primary.withOpacity(0.4),
                          strokeWidth: 2,
                          gap: 8,
                          radius: 16,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 56, // w-14
                                  height: 56, // h-14
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0x33009669,
                                        ), // shadow-primary/20
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 16), // mb-4
                                Text(
                                  'Tap to upload photo',
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    fontSize: 14, // text-sm
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(
                                            0xFF111827,
                                          ), // neutral-900
                                  ),
                                ),
                                const SizedBox(height: 4), // mb-1
                                Text(
                                  'SVG, PNG, JPG or PDF\n(max. 800x400px)',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.neutral400
                                        : AppColors.neutral500,
                                    height: 1.5,
                                    fontSize: 12, // text-xs
                                  ),
                                ),
                                const SizedBox(height: 20), // mb-5
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // rounded-lg
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Browse Gallery',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12, // text-xs
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  ),
                ),
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Next Step',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      // Navigation
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // rounded-xl
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2,
    this.gap = 5,
    this.radius = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final Path dashedPath = _dashPath(
      path,
      dashArray: _CircularIntervalList([10.0, gap]),
    );
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(
    Path source, {
    required _CircularIntervalList<double> dashArray,
  }) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = dashArray.next;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _CircularIntervalList<T> {
  final List<T> _vals;
  int _idx = 0;
  _CircularIntervalList(this._vals);
  T get next {
    if (_idx >= _vals.length) _idx = 0;
    return _vals[_idx++];
  }
}
