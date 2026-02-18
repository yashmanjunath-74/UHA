import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class PatientDigitalFileView extends StatelessWidget {
  const PatientDigitalFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Patient 360°'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name
            const Text(
              'Sarah Jenkins',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 24),

            // AI Health Insight Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'AI Health Insight',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Summary: Patient has history of Asthma (2019). Allergic to Dust. Last visit was 2 months ago for Flu symptoms. Vitals are currently stable.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Medical Records
            _buildRecordCard(
              'General Consultation',
              'Dr. Smith • Family Medicine',
              'Reported high fever and fatigue. Diagnosed with seasonal flu. Prescribed Tamiflu and rest.',
              Icons.medical_services,
            ),
            const SizedBox(height: 12),
            _buildRecordCard(
              'Lab Results: Blood Panel',
              'Central Lab • Ref #88392',
              '',
              Icons.science,
            ),
            const SizedBox(height: 12),
            _buildRecordCard(
              'Vaccination',
              'Community Clinic',
              'COVID-19 Booster Shot (Pfizer-BioNTech)',
              Icons.vaccines,
            ),
            const SizedBox(height: 12),
            _buildRecordCard(
              'Initial Diagnosis',
              'City Hospital',
              'Patient presented with shortness of breath. Pulmonary function test confirmed mild asthma.',
              Icons.local_hospital,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(
    String title,
    String subtitle,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neutral700,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
