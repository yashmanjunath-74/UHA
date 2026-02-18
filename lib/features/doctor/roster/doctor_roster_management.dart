import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class DoctorRosterManagement extends StatelessWidget {
  const DoctorRosterManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Roster Management'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage shifts & staff',
              style: TextStyle(fontSize: 16, color: AppColors.neutral600),
            ),
            const SizedBox(height: 24),

            // Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'October 2023',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Morning Shift
            _buildShiftSection('Morning Shift', [
              {'name': 'Dr. Alan Grant', 'specialty': 'Cardiology'},
              {'name': 'Dr. Ellie Sattler', 'specialty': 'Pediatrics'},
            ]),
            const SizedBox(height: 20),

            // Evening Shift
            _buildShiftSection('Evening Shift', [
              {'name': 'Dr. Ian Malcolm', 'specialty': 'Neurology'},
            ]),
            const SizedBox(height: 20),

            // Night Shift
            _buildShiftSection('Night Shift', []),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildShiftSection(String title, List<Map<String, String>> doctors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
        ),
        const SizedBox(height: 12),
        if (doctors.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.neutral200,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text(
                'No doctors assigned',
                style: TextStyle(fontSize: 14, color: AppColors.neutral500),
              ),
            ),
          )
        else
          ...doctors.map(
            (doctor) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor['specialty']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.neutral600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
