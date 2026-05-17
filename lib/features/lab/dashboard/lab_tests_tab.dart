import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/lab_controller.dart';
import '../../../models/lab_order_model.dart';
import 'lab_result_upload_screen.dart';
import '../providers/lab_provider.dart';

class LabTestsTab extends ConsumerWidget {
  const LabTestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(labOrdersProvider);
    return SafeArea(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Lab Tests & Appointments', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 16),
            _searchBar(),
            const SizedBox(height: 16),
            _filterChips(ref),
          ]),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        Expanded(
          child: ordersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return const Center(child: Text('No lab orders found.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: orders.length,
                itemBuilder: (context, i) {
                  return _testListItem(context, orders[i]);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ]),
    );
  }

  Widget _searchBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: const TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
            hintText: 'Search patient, test ID...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            border: InputBorder.none,
          ),
        ),
      );

  Widget _testListItem(BuildContext context, LabOrderModel order) {
    final isDone = order.status == 'Completed';
    final idStr = order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id;

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(children: [
          Row(children: [
            CircleAvatar(radius: 20, backgroundColor: const Color(0xFFF1F5F9), child: const Icon(Icons.person, size: 24, color: Color(0xFF64748B))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
              Text('Test ID: #$idStr  •  ${order.patientAge} Y/O  •  ${order.patientGender}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isDone ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
              child: Text(order.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDone ? const Color(0xFF10B981) : const Color(0xFFF59E0B)))),
          ]),
          const SizedBox(height: 16),
          _testDetailRow('Test Name', order.testName),
          _testDetailRow('Scheduled', order.time),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          Row(children: [
            Expanded(
              child: _actionButton(
                context,
                isDone ? Icons.visibility_outlined : Icons.upload_file_outlined,
                isDone ? 'View Report' : 'Upload Result',
                isDone ? const Color(0xFF64748B) : const Color(0xFF10B981),
                onTap: () {
                  if (isDone) {
                    // Show report
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LabResultUploadScreen(orderId: order.id),
                      ),
                    );
                  }
                },
              ),
            ),
            if (!isDone) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  context,
                  Icons.edit_note_outlined,
                  'Edit Info',
                  const Color(0xFF6366F1),
                  onTap: () {},
                ),
              ),
            ],
          ]),
        ]),
      );
  }

  Widget _testDetailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Text('$label: ', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        ]),
      );

  Widget _filterChips(WidgetRef ref) {
    final selectedFilter = ref.watch(labFilterProvider);
    final filters = ['All', 'New', 'Testing', 'Completed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(labFilterProvider.notifier).update(filter);
                }
              },
              selectedColor: const Color(0xFF10B981).withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: const Color(0xFFF8FAFC),
              side: BorderSide(
                color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      );
}
