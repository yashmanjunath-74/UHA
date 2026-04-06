import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Premium Pharmacy Order Fulfillment screen — matches the UI screenshot.
class PharmacyOrderFulfillment extends ConsumerStatefulWidget {
  const PharmacyOrderFulfillment({super.key});

  @override
  ConsumerState<PharmacyOrderFulfillment> createState() =>
      _PharmacyOrderFulfillmentState();
}

class _PharmacyOrderFulfillmentState
    extends ConsumerState<PharmacyOrderFulfillment> {
  final List<bool> _steps = [false, false, false]; // Verify, Expiry, Pack

  bool get _allDone => _steps.every((s) => s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Column(children: [
          // ── App Bar ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ORDER #10234', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                Text('Fulfillment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                child: const Text('Pending', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)))),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert, color: Color(0xFF64748B)),
            ]),
          ),

          // ── Scrollable Body ──────────────────────────────────────
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Patient card
              _buildPatientCard(),
              const SizedBox(height: 14),

              // Prescription card
              _buildPrescriptionCard(),
              const SizedBox(height: 20),

              // Fulfillment Steps
              const Text('FULFILLMENT STEPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
              const SizedBox(height: 12),
              _buildStepCard(0, 'Verify Medication', 'Confirm NDC match', buttonLabel: 'Scan Bottle Barcode', buttonIcon: Icons.qr_code_scanner_rounded),
              const SizedBox(height: 10),
              _buildStepCard(1, 'Check Expiry', 'Must be > 06/2025'),
              const SizedBox(height: 10),
              _buildStepCard(2, 'Pack Order', 'Seal and label the package'),
              const SizedBox(height: 80), // bottom spacing for buttons
            ]),
          )),

          // ── Bottom Actions ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Column(children: [
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFF475569)),
                  label: const Text('Query Doctor', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_outline, size: 16, color: Color(0xFF475569)),
                  label: const Text('Contact Patient', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _allDone ? () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order marked as Ready for Pickup!'), backgroundColor: Color(0xFF10B981)));
                    Navigator.pop(context);
                  } : null,
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: const Text('Mark as Ready', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: _allDone ? 4 : 0,
                    shadowColor: const Color(0xFF10B981).withOpacity(0.4),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: const BorderSide(color: Color(0xFF10B981), width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 22, backgroundColor: const Color(0xFFE8F5F1), child: const Text('SJ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 14))),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sarah Jenkins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            Text('ID: P-9982  •  45 Y/O  •  Female', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ])),
          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(10)),
          child: const Row(children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 16),
            SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CRITICAL ALERT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEF4444), letterSpacing: 0.5)),
              Text('Allergy: Penicillin (Severe)', style: TextStyle(fontSize: 12, color: Color(0xFFEF4444), fontWeight: FontWeight.w500)),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPrescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.description_outlined, color: Color(0xFF10B981), size: 18)),
            const SizedBox(width: 8),
            const Text('Prescription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
          ]),
          const Text('Issued: Today, 9:00 AM', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ]),
        const Divider(height: 20, color: Color(0xFFF1F5F9)),

        // Drug
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Amoxicillin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Text('500mg Capsules', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF10B981))),
          ]),
          const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('30', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Text('QUANTITY', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ]),
        ]),
        const SizedBox(height: 12),

        // Instructions
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
          child: const Text('"Take 1 capsule by mouth three times daily for 10 days."', style: TextStyle(fontSize: 13, color: Color(0xFF475569), fontStyle: FontStyle.italic)),
        ),
        const SizedBox(height: 12),

        // Doctor
        Row(children: [
          CircleAvatar(radius: 16, backgroundColor: const Color(0xFFE8F5F1), child: const Icon(Icons.person, size: 18, color: Color(0xFF10B981))),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Dr. Emily Chen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
            Text('Cardiologist  •  LIC #88392', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ]),
          const Spacer(),
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.qr_code_2_rounded, size: 20, color: Color(0xFF475569))),
        ]),
      ]),
    );
  }

  Widget _buildStepCard(int index, String title, String subtitle, {String? buttonLabel, IconData? buttonIcon}) {
    final done = _steps[index];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: done ? const Color(0xFF10B981) : const Color(0xFFE2E8F0), width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          // Step number circle
          Container(width: 32, height: 32, decoration: BoxDecoration(
            color: done ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ), alignment: Alignment.center,
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: done ? const Color(0xFF64748B) : const Color(0xFF1E293B),
              decoration: done ? TextDecoration.lineThrough : TextDecoration.none)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          ])),
          Switch.adaptive(
            value: done,
            onChanged: (v) => setState(() => _steps[index] = v),
            activeColor: const Color(0xFF10B981),
          ),
        ]),
        if (buttonLabel != null && !done) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(buttonIcon ?? Icons.qr_code_scanner_rounded, size: 18, color: const Color(0xFF475569)),
                const SizedBox(width: 8),
                Text(buttonLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
              ]),
            ),
          ),
        ],
      ]),
    );
  }
}
