import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class PharmacyPayoutSetupScreen extends StatelessWidget {
  const PharmacyPayoutSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Payout Setup'),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: const Center(
        child: Text('Pharmacy Payout Setup - Implementation Pending'),
      ),
    );
  }
}
