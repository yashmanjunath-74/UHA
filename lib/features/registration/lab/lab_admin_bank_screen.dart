import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class LabAdminBankScreen extends StatelessWidget {
  const LabAdminBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Admin & Bank Setup'),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: const Center(
        child: Text('Lab Admin & Bank Setup - Implementation Pending'),
      ),
    );
  }
}
