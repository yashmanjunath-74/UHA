import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../pharmacy/controller/pharmacy_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/controller/auth_controller.dart';

class PharmacyListScreen extends ConsumerWidget {
  const PharmacyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmaciesAsync = ref.watch(allPharmaciesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Find Pharmacies', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.neutral900)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.neutral900),
      ),
      body: pharmaciesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading pharmacies: $e')),
        data: (pharmacies) {
          if (pharmacies.isEmpty) {
            return const Center(child: Text('No pharmacies found'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pharmacies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final pharmacy = pharmacies[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_pharmacy_rounded, color: AppColors.primary, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pharmacy.name,
                                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral900),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: AppColors.neutral500),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${pharmacy.address ?? "No address"}, ${pharmacy.city ?? "Unknown City"}',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _placeOrderDialog(context, ref, pharmacy.id, pharmacy.name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Send Prescription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _placeOrderDialog(BuildContext context, WidgetRef ref, String pharmacyId, String pharmacyName) {
    final user = ref.read(authProvider).session?.user;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Order from $pharmacyName', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Do you want to send your latest medical prescription to this pharmacy for fulfillment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              // Place mock order to backend
              try {
                final orderData = {
                  'pharmacy_id': pharmacyId,
                  'patient_id': user?.id,
                  'patient_name': user?.userMetadata?['name'] ?? 'Guest Patient',
                  'patient_age': 30, // Mock age
                  'patient_gender': 'Unknown',
                  'status': 'New',
                  'is_urgent': false,
                  'doctor_name': 'Self Requested',
                  'items': [
                    {'name': 'Paracetamol', 'dosage': '500mg', 'quantity': 10, 'instructions': 'Take as needed'}
                  ]
                };
                
                await ref.read(pharmacyControllerProvider).placeOrder(orderData);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Prescription sent to $pharmacyName successfully!'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to place order: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}
