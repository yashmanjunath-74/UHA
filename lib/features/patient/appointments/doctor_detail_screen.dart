import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/doctor_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/patient_controller.dart';

class DoctorDetailScreen extends ConsumerWidget {
  final DoctorModel doctor;

  const DoctorDetailScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Doctor Image Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.network(
              doctor.avatarUrl ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuC9s6caATreQl8lsqAZ4Sjxbij1sV7DWXDvUl-UjBxweezGFPEvyMVvBKwE1Yh7X7mtGHm55kZg8MlRA_8oA27IaqAyDiA3amZbofK4jS4fw3GWCkcEfJfohcKRDYN4-E9_7WnbrQtDiD9OrPnWj1L1kvF9xLV9ACsmoS0ncXpF_YThCZK29KVSV8JcqYpVr-wtt7RP1LJtL92RQHKuCjcC_jiPyzkyHM2YwHdOMKFX1AzzA3tHzwBOJJDfE9QX2ibUYewYFI3dvNUR',
              fit: BoxFit.cover,
            ),
          ),

          // Custom App Bar Back Button
          Positioned(
            top: 40,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),

          // Content Wrapper
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.fullName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              '${doctor.specialty} • ${doctor.qualification}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star_rounded, color: Color(0xFF10B981), size: 18),
                              SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'About Doctor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dr. ${doctor.fullName.split(' ').last} is a highly qualified ${doctor.specialty} with over ${doctor.yearsOfExperience} years of experience. ${doctor.clinicAddress != null ? "Currently practicing at ${doctor.clinicAddress}." : ""}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Stats Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox('Patients', '5,000+', const Color(0xFFDBEAFE), const Color(0xFF2563EB)),
                        _buildStatBox('Experience', '${doctor.yearsOfExperience} Years', const Color(0xFFDCFCE7), const Color(0xFF10B981)),
                        _buildStatBox('Reviews', '1.2K', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                      ],
                    ),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBookingBar(context, ref),
    );
  }

  Widget _buildStatBox(String label, String value, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: iconColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildBottomBookingBar(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF10B981)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final userId = ref.read(authProvider).session?.user.id;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to book an appointment')),
                    );
                    return;
                  }

                  // Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  final result = await ref.read(appointmentRepositoryProvider).bookAppointment(
                    patientId: userId,
                    doctorId: doctor.id,
                    scheduledAt: DateTime.now().add(const Duration(days: 1)), // Mocking tomorrow
                    fee: doctor.consultationFee,
                  );

                  if (context.mounted) Navigator.pop(context); // Pop loading

                  result.fold(
                    (failure) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.message)),
                    ),
                    (appointment) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment booked successfully!'), backgroundColor: Color(0xFF10B981)),
                      );
                      Navigator.pop(context);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
