import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/lab_model.dart';
import '../../lab/controller/lab_controller.dart';
import '../../auth/controller/auth_controller.dart';

class BookLabTestScreen extends ConsumerStatefulWidget {
  final LabModel lab;
  
  const BookLabTestScreen({super.key, required this.lab});

  @override
  ConsumerState<BookLabTestScreen> createState() => _BookLabTestScreenState();
}

class _BookLabTestScreenState extends ConsumerState<BookLabTestScreen> {
  String? selectedTest;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Book Lab Test'),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select a test at ${widget.lab.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Test Type',
                border: OutlineInputBorder(),
              ),
              value: selectedTest,
              items: widget.lab.testTypes.map((test) => DropdownMenuItem(
                value: test,
                child: Text(test),
              )).toList(),
              onChanged: (val) {
                setState(() => selectedTest = val);
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedTest == null ? null : () async {
                  final user = ref.read(authProvider).session?.user;
                  if (user == null) return;
                  
                  try {
                    final orderData = {
                      'lab_id': widget.lab.id,
                      'patient_id': user.id,
                      'patient_name': user.userMetadata?['full_name'] ?? 'Guest Patient',
                      'patient_age': 30, // Mock
                      'patient_gender': 'Unknown',
                      'test_name': selectedTest,
                      'status': 'New',
                    };
                    
                    await ref.read(labControllerProvider).placeOrder(orderData);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lab test booked successfully!'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context); // Go back to Lab list
                      Navigator.pop(context); // Go back to Home
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
