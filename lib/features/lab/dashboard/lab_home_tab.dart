import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controller/lab_controller.dart';
import '../../../models/lab_order_model.dart';

class LabHomeTab extends ConsumerWidget {
  const LabHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(labProfileProvider);
    final ordersAsync = ref.watch(labOrdersProvider);

    return SafeArea(
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile == null) return const Center(child: Text('No Profile Found'));
          
          return ordersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading orders: $err')),
            data: (orders) {
              final newOrders = orders.where((o) => o.status == 'New' || o.status == 'Testing').toList();
              final completedOrders = orders.where((o) => o.status == 'Completed').toList();
              final todayDate = DateFormat('EEEE, MMM d').format(DateTime.now());
              
              // Revenue calculation mock based on completed orders
              final revenue = completedOrders.length * 850;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(todayDate, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(profile.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const Text('Universal Health App', style: TextStyle(fontSize: 13, color: Color(0xFF10B981), fontWeight: FontWeight.w500)),
                      ]),
                      const CircleAvatar(radius: 22, backgroundColor: Colors.white, child: Icon(Icons.biotech, color: Color(0xFF10B981))),
                    ]),
                    const SizedBox(height: 24),

                    // Overview Stats
                    Row(children: [
                      _statItem('${orders.length}', 'Total Tests', const Color(0xFF10B981), Icons.assignment_turned_in_outlined),
                      const SizedBox(width: 12),
                      _statItem('${newOrders.length}', 'Pending Reports', const Color(0xFFF59E0B), Icons.pending_actions),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      _statItem('₹$revenue', 'Est Revenue', const Color(0xFF6366F1), Icons.payments_outlined),
                      const SizedBox(width: 12),
                      _statItem('4.9', 'Lab Rating', const Color(0xFF8B5CF6), Icons.star_outline_rounded),
                    ]),
                    const SizedBox(height: 24),

                    // Payout Banner
                    _payoutBanner(),
                    const SizedBox(height: 24),

                    // Recent Bookings
                    const Text('Upcoming Tests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 12),
                    
                    if (newOrders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No upcoming tests.', style: TextStyle(color: Color(0xFF94A3B8))),
                      )
                    else
                      ...newOrders.take(5).map((order) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _testCard(
                            order.patientName, 
                            order.testName, 
                            order.time.length > 16 ? order.time.substring(11, 16) : order.time, 
                            order.status, 
                            const Color(0xFFF59E0B)
                          ),
                        );
                      }),
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }


  Widget _statItem(String value, String label, Color color, IconData icon) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ]),
        ),
      );

  Widget _payoutBanner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Instant Payout Ready', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Available Balance: ₹8,900', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ]),
          Icon(Icons.arrow_circle_right_rounded, color: Colors.white, size: 32),
        ]),
      );

  Widget _testCard(String patient, String testName, String time, String status, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: color, width: 4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(patient, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Text(testName, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))),
          ]),
        ]),
      );
}
