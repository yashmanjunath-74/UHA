import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class PharmacyBusinessDetailsScreen extends StatelessWidget {
  const PharmacyBusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Business Details'),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: const Center(
        child: Text('Pharmacy Business Details - Implementation Pending'),
      ),
    );
  }
}
