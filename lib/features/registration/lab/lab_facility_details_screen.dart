import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class LabFacilityDetailsScreen extends StatelessWidget {
  const LabFacilityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Facility Details'),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: const Center(
        child: Text('Lab Facility Details - Implementation Pending'),
      ),
    );
  }
}
