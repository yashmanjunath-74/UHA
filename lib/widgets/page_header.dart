import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const PageHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBackPressed ?? () => Navigator.maybePop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: isDark ? AppColors.neutral300 : AppColors.neutral600,
            ),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.neutral800.withOpacity(0.5)
                  : Colors.transparent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
          ),
          Text(
            title,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
