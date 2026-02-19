import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/core/theme/app_text_styles.dart';

class BookingPaymentConfirm extends StatefulWidget {
  const BookingPaymentConfirm({super.key});

  @override
  State<BookingPaymentConfirm> createState() => _BookingPaymentConfirmState();
}

class _BookingPaymentConfirmState extends State<BookingPaymentConfirm> {
  int _selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: isDark ? Colors.white : AppColors.neutral900),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : AppColors.neutral900,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            _buildOrderSummary(isDark),
            const SizedBox(height: 24),
            Text(
              'Payment Method',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethods(isDark),
            const SizedBox(height: 24),
            _buildPromoCode(isDark),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                  ),
                  Text(
                    '₹800.00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.neutral900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Simulate payment success
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          _buildSuccessDialog(context, isDark),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm & Pay ₹800',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 14, color: AppColors.neutral500),
                  const SizedBox(width: 4),
                  Text(
                    'Secure Payment',
                    style: TextStyle(fontSize: 12, color: AppColors.neutral500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Emily Chen',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.neutral900,
                      ),
                    ),
                    Text(
                      'Cardiologist • Apollo Hospital',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tue, 24 Feb • 10:30 AM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildSummaryRow('Consultation Fee', '₹1000.00', isDark),
          const SizedBox(height: 8),
          _buildSummaryRow('Booking Fee', '₹50.00', isDark),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Discount (First Booking)',
            '- ₹250.00',
            isDark,
            isDiscount: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.neutral400 : AppColors.neutral600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDiscount
                ? AppColors.success
                : (isDark ? Colors.white : AppColors.neutral900),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(bool isDark) {
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
          _buildPaymentOption(
            0,
            'Credit / Debit Card',
            '**** **** **** 4242',
            Icons.credit_card,
            isDark,
          ),
          const Divider(height: 1),
          _buildPaymentOption(
            1,
            'UPI',
            'Google Pay, PhonePe, Paytm',
            Icons.qr_code,
            isDark,
          ),
          const Divider(height: 1),
          _buildPaymentOption(
            2,
            'Net Banking',
            'All Indian banks',
            Icons.account_balance,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    int index,
    String title,
    String subtitle,
    IconData icon,
    bool isDark,
  ) {
    return RadioListTile(
      value: index,
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value as int;
        });
      },
      activeColor: AppColors.primary,
      title: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isDark ? AppColors.neutral300 : AppColors.neutral700,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.neutral900,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 36),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.neutral400 : AppColors.neutral500,
          ),
        ),
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildPromoCode(bool isDark) {
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
        children: [
          const Icon(Icons.local_offer_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            'Apply Promo Code',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.neutral900,
            ),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('Select')),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog(BuildContext context, bool isDark) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 32,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment has been confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
