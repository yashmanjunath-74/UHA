import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../pharmacy/controller/pharmacy_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/controller/auth_controller.dart';

final allMedicinesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await Supabase.instance.client.from('pharmacy_inventory').select();
  return List<Map<String, dynamic>>.from(res);
});

class PharmacyListScreen extends ConsumerWidget {
  const PharmacyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Find Meds & Pharmacies', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.neutral900),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.neutral500,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Available Meds'),
              Tab(text: 'Pharmacies'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMedicinesTab(ref),
            _buildPharmaciesTab(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicinesTab(WidgetRef ref) {
    final medsAsync = ref.watch(allMedicinesProvider);
    return medsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading meds: $e')),
      data: (meds) {
        if (meds.isEmpty) return const Center(child: Text('No medicines found in database'));
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: meds.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final med = meds[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.neutral100)),
              child: Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.medication, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(med['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(med['category'] ?? 'Category', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text('₹${med['price'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPharmaciesTab(WidgetRef ref) {
    final pharmaciesAsync = ref.watch(allPharmaciesProvider);
    return pharmaciesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text('Failed to load pharmacies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(e.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(allPharmaciesProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (pharmacies) {
        if (pharmacies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_pharmacy_outlined, size: 64, color: AppColors.primary),
                SizedBox(height: 16),
                Text('No Pharmacies Registered Yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text('Pharmacies will appear here once they join the network.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          );
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
                        // Verified badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: pharmacy.verificationStatus.name == 'verified'
                                ? const Color(0xFFD1FAE5)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pharmacy.verificationStatus.name == 'verified' ? '✓ Verified' : 'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: pharmacy.verificationStatus.name == 'verified'
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF92400E),
                            ),
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
    );
  }


  void _placeOrderDialog(BuildContext context, WidgetRef ref, String pharmacyId, String pharmacyName) {
    final user = ref.read(authProvider).session?.user;
    bool attachPrescription = false;
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Order from $pharmacyName', style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Do you want to send a medical prescription to this pharmacy for fulfillment?'),
                const SizedBox(height: 20),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Attach Prescription Image', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Simulate uploading your prescription document', style: TextStyle(fontSize: 12)),
                  value: attachPrescription,
                  onChanged: (val) {
                    setState(() { attachPrescription = val ?? false; });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  
                  try {
                    final items = [
                      {'name': 'Paracetamol', 'dosage': '500mg', 'quantity': 10, 'instructions': 'Take as needed'}
                    ];
                    
                    if (attachPrescription) {
                      items.add({
                        'name': 'Scanned Prescription', 
                        'dosage': '', 
                        'quantity': 1, 
                        'instructions': 'IMAGE_LINK|https://images.unsplash.com/photo-1587854692152-cbe660dbbb88?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'
                      });
                    }

                    final orderData = {
                      'pharmacy_id': pharmacyId,
                      'patient_id': user?.id,
                      'patient_name': user?.userMetadata?['full_name'] ?? user?.userMetadata?['name'] ?? 'Guest Patient',
                      'patient_age': 30, // Mock age
                      'patient_gender': 'Unknown',
                      'status': 'New',
                      'is_urgent': false,
                      'doctor_name': 'Self Requested',
                      'items': items
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
                child: const Text('Send Order'),
              ),
            ],
          );
        }
      ),
    );
  }
}
