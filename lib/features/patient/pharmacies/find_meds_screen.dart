import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/pharmacy_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../pharmacy/controller/pharmacy_controller.dart';

// ── Provider — direct Supabase query with timeout ───────────────────────────

final pharmaciesFromDbProvider = FutureProvider<List<PharmacyModel>>((ref) async {
  try {
    // Direct query — bypasses repository to rule out wrapper issues
    final response = await Supabase.instance.client
        .from('pharmacies')
        .select()
        .timeout(const Duration(seconds: 10));

    final list = (response as List)
        .map((row) => PharmacyModel.fromMap(row as Map<String, dynamic>))
        .toList();

    debugPrint('✅ Pharmacies fetched: ${list.length}');
    return list;
  } catch (e, st) {
    debugPrint('❌ Pharmacy fetch error: $e');
    debugPrint(st.toString());
    rethrow;
  }
});

// ── Screen ──────────────────────────────────────────────────────────────────

class FindMedsScreen extends ConsumerWidget {
  const FindMedsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmaciesAsync = ref.watch(pharmaciesFromDbProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Nearby Pharmacies',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF10B981)),
            onPressed: () => ref.invalidate(pharmaciesFromDbProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pharmacies by name or city...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // List
          Expanded(
            child: pharmaciesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF10B981)),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      const Text('Failed to load pharmacies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(err.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(pharmaciesFromDbProvider),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
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
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_pharmacy_outlined, size: 80, color: Color(0xFF10B981)),
                        const SizedBox(height: 16),
                        const Text('No Pharmacies Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('No registered pharmacies in the network yet.', style: TextStyle(color: Color(0xFF64748B))),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = pharmacies[index];
                    return _PharmacyCard(pharmacy: pharmacy);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pharmacy Card ────────────────────────────────────────────────────────────

class _PharmacyCard extends ConsumerWidget {
  final PharmacyModel pharmacy;

  const _PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerified = pharmacy.verificationStatus.name == 'verified';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.local_pharmacy_rounded, color: Color(0xFF9333EA), size: 28),
                ),
                const SizedBox(width: 14),
                // Name & city
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (pharmacy.city != null)
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                            Text(
                              pharmacy.city!,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Verified badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? const Color(0xFFD1FAE5)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isVerified ? '✓ Verified' : 'Pending',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isVerified ? const Color(0xFF065F46) : const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),

            if (pharmacy.address != null) ...[
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.place_outlined, size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pharmacy.address!,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone_outlined, size: 16),
                    label: const Text('Contact'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9333EA),
                      side: const BorderSide(color: Color(0xFFE9D5FF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isVerified ? () => _placeOrderDialog(context, ref, pharmacy.id, pharmacy.name) : null,
                    icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                    label: const Text('Order Meds'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                  activeColor: const Color(0xFF10B981),
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
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B)))),
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
                  backgroundColor: const Color(0xFF10B981),
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
