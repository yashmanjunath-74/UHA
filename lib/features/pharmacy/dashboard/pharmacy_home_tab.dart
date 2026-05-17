import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/constants/constants.dart';
import '../../auth/controller/auth_controller.dart';
import '../fulfillment/pharmacy_order_fulfillment.dart';
import 'pharmacy_profile_screen.dart';
import '../controller/pharmacy_controller.dart';
import '../providers/pharmacy_provider.dart';

class PharmacyHomeTab extends ConsumerWidget {
  const PharmacyHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(pharmacyProfileProvider);
    final ordersAsync = ref.watch(pharmacyOrdersProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()), style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                profileAsync.when(
                  data: (profile) => Text(profile?.name ?? 'Pharmacy Dashboard', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  loading: () => const Text('Loading...', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  error: (_, __) => const Text('Pharmacy Dashboard', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ),
                const Text('Universal Health App', style: TextStyle(fontSize: 13, color: Color(0xFF10B981), fontWeight: FontWeight.w500)),
              ])),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyProfileScreen())),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
                      child: const Icon(Icons.person_rounded, color: Color(0xFF10B981)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _confirmLogout(context, ref),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFECACA))),
                      child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20),

            // ── Stats Row ───────────────────────────────────────────
            ordersAsync.when(
              data: (orders) {
                final newCount = orders.where((o) => o.status == 'New').length;
                final prepCount = orders.where((o) => o.status == 'Preparing').length;
                final readyCount = orders.where((o) => o.status == 'Ready').length;

                return Row(children: [
                  _stat(newCount.toString(), 'New Orders', const Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  _stat(prepCount.toString(), 'Processing', const Color(0xFFF59E0B)),
                  const SizedBox(width: 10),
                  _stat(readyCount.toString(), 'Ready', const Color(0xFF6366F1)),
                ]);
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const Text('Could not load stats'),
            ),
            const SizedBox(height: 20),

            // ── Request Instant Payout Banner ───────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 12, offset: const Offset(0,4))],
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text('Request Instant Payout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Quick Actions ───────────────────────────────────────
            const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Row(children: [
              _quickAction(Icons.qr_code_scanner_rounded, 'Scan Rx', const Color(0xFF2C6BFF)),
              const SizedBox(width: 12),
              _quickAction(Icons.inventory_2_outlined, 'Inventory', const Color(0xFF10B981)),
              const SizedBox(width: 12),
              _quickAction(Icons.delivery_dining_rounded, 'Deliveries', const Color(0xFFF59E0B)),
              const SizedBox(width: 12),
              _quickAction(Icons.bar_chart_rounded, 'Reports', const Color(0xFF8B5CF6)),
            ]),
            const SizedBox(height: 20),

            // ── Pending Orders ──────────────────────────────────────
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Pending Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.w600))),
            ]),
            const SizedBox(height: 10),
            
            ordersAsync.when(
              data: (orders) {
                final pendingOrders = orders.where((o) => o.status == 'New' || o.status == 'Preparing').take(4).toList();
                if (pendingOrders.isEmpty) {
                  return const Text('No pending orders right now', style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: pendingOrders.map((order) {
                    final meds = order.items.isNotEmpty ? '${order.items.first.name} ${order.items.first.dosage}' : 'No meds listed';
                    final color = order.status == 'New' ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _orderCard(
                        context,
                        '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}',
                        order.patientName,
                        meds,
                        order.time,
                        order.status,
                        color,
                        order,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const Text('Failed to fetch orders'),
            ),
            const SizedBox(height: 10),

            // ── Inventory Alerts ────────────────────────────────────
            const Text('Inventory Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 10),
            _inventoryAlert('Amoxicillin 500mg', 'Only 12 strips left', const Color(0xFFEF4444)),
            const SizedBox(height: 8),
            _inventoryAlert('Paracetamol 650mg', 'Expires in 15 days', const Color(0xFFF59E0B)),
            const SizedBox(height: 8),
            _inventoryAlert('Insulin Glargine', 'Reorder needed — 3 vials', const Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ]),
    ),
  );

  Widget _quickAction(IconData icon, String label, Color color) => Expanded(
    child: GestureDetector(
      onTap: () {},
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF475569)), textAlign: TextAlign.center),
      ]),
    ),
  );

  Widget _orderCard(BuildContext context, String orderId, String patientName, String meds, String time, String status, Color statusColor, PharmacyOrder order) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyOrderFulfillment())),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: statusColor, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                child: Text(
                  orderId,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontFamily: 'monospace'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              patientName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              meds,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(8)),
              child: const Text('Fulfill', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
        ]),
      ),
    );
  }

  Widget _inventoryAlert(String name, String detail, Color color) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
    child: Row(children: [
      Icon(Icons.warning_amber_rounded, color: color, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
        Text(detail, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
      ])),
      const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 18),
    ]),
  );

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Log Out?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to log out of the Pharmacy Dashboard?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await ref.read(authRepositoryProvider).signOut();
            if (context.mounted) Routemaster.of(context).replace(AppConstants.routeLogin);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Log Out'),
        ),
      ],
    ));
  }
}
