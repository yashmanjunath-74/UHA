import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/registration_provider.dart';
import 'steps/step_1_basic_info.dart';
import 'steps/step_2_verification.dart';
import 'steps/step_3_security.dart';

class PatientRegistrationScreen extends ConsumerWidget {
  const PatientRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registrationProvider);
    final notifier = ref.read(registrationProvider.notifier);

    ref.listen(registrationProvider, (previous, next) {
      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        // Navigate to Success Screen
        Navigator.of(context).pushNamed(
          '/success',
        ); // Or pushReplacement if we want to clear stack partially
      }
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    // Custom Green Color
    const emeraldGreen = Color(0xFF00A67E);
    const bgGreen = Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: bgGreen,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (state.currentStep > 0) {
              notifier.previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _getTitle(state.currentStep),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: bgGreen,
        elevation: 0,
        foregroundColor: const Color(0xFF111827),
      ),
      body: Column(
        children: [
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${state.currentStep + 1} of 3',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((state.currentStep + 1) / 3 * 100).toInt()}%',
                      style: const TextStyle(
                        color: emeraldGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (state.currentStep + 1) / 3,
                    backgroundColor: emeraldGreen.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      emeraldGreen,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildStep(state.currentStep),
            ),
          ),

          // Navigation Buttons (Move to inside steps if form validation is needed per step)
          // For now, keeping global for shell structure
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (state.currentStep < 2) {
                              notifier.nextStep();
                            } else {
                              notifier.submitRegistration();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            state.currentStep == 2
                                ? 'Complete Registration'
                                : 'Next Step',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                if (state.currentStep > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: notifier.previousStep,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Verification';
      case 2:
        return 'Security';
      default:
        return 'Registration';
    }
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return const Step1BasicInfo();
      case 1:
        return const Step2Verification();
      case 2:
        return const Step3Security();
      default:
        return const SizedBox();
    }
  }
}
