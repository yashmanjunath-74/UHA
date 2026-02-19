import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/core/theme/app_text_styles.dart';

class PharmacyOrderFulfillment extends ConsumerStatefulWidget {
  const PharmacyOrderFulfillment({super.key});

  @override
  ConsumerState<PharmacyOrderFulfillment> createState() =>
      _PharmacyOrderFulfillmentState();
}

class _PharmacyOrderFulfillmentState
    extends ConsumerState<PharmacyOrderFulfillment> {
  final List<bool> _stepsCompleted = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Order Fulfillment',
          style: TextStyle(color: isDark ? Colors.white : AppColors.neutral900),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : AppColors.neutral900,
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, size: 18),
            label: const Text('Help'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientProfile(isDark),
            const SizedBox(height: 24),
            Text(
              'Digital Prescription',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            _buildPrescriptionCard(isDark),
            const SizedBox(height: 24),
            Text(
              'Fulfillment Checklist',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            _buildFulfillmentSteps(isDark),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.neutral700
                          : AppColors.neutral300,
                    ),
                  ),
                  child: Text(
                    'Hold Order',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.neutral900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _stepsCompleted.every((step) => step)
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order marked as Ready for Pickup'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.neutral300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Mark as Ready',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientProfile(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              'SJ',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Jenkins',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral900,
                  ),
                ),
                Text(
                  'ID: P-9982 • 45 Y • Female',
                  style: TextStyle(
                    color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Allergic to Penicillin',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.description, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Emily Chen',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.neutral900,
                      ),
                    ),
                    Text(
                      'Cardiologist • #DOC-8822',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0
                                ? 'Amoxicillin 500mg'
                                : 'Paracetamol 500mg',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: 30 • Take 1 tablet every 8 hours',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.backgroundDark
                  : AppColors.neutral50.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Digital Signature Validated',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.verified, size: 16, color: AppColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFulfillmentSteps(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        ),
      ),
      child: Column(
        children: [
          _buildCheckboxStep(
            0,
            'Verify Prescription',
            'Check doctor signature and patient details match.',
            isDark,
          ),
          const Divider(height: 1),
          _buildCheckboxStep(
            1,
            'Check Expiry & Stock',
            'Ensure medicines are in stock and not expired.',
            isDark,
          ),
          const Divider(height: 1),
          _buildCheckboxStep(
            2,
            'Pack & Label',
            'Pack medicines and attach usage instructions.',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxStep(
    int index,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return CheckboxListTile(
      value: _stepsCompleted[index],
      onChanged: (value) {
        setState(() {
          _stepsCompleted[index] = value ?? false;
        });
      },
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.neutral900,
          decoration: _stepsCompleted[index]
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? AppColors.neutral400 : AppColors.neutral500,
          fontSize: 12,
        ),
      ),
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
