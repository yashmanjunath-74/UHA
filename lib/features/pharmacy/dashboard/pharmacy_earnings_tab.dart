import 'package:flutter/material.dart';

/// Premium re-built Earnings tab (matching the UI screenshot exactly).
class PharmacyEarningsTab extends StatefulWidget {
  const PharmacyEarningsTab({super.key});
  @override State<PharmacyEarningsTab> createState() => _PharmacyEarningsTabState();
}

class _PharmacyEarningsTabState extends State<PharmacyEarningsTab> {
  // Monthly data — 30 data points
  final List<double> _monthly = [
    0.3, 0.5, 0.4, 0.7, 0.6, 0.5, 0.8, 0.6, 0.4, 0.7,
    0.9, 0.5, 0.7, 0.95, 0.6, 0.55, 0.7, 0.8, 0.6, 0.5,
    0.7, 0.4, 0.6, 0.75, 0.8, 0.65, 0.5, 0.7, 0.85, 0.9,
  ];

  final _payouts = [
    {'date': 'Oct 24, 2023', 'id': '#TXN-9982', 'amount': '\$1,200.00', 'status': 'TRANSFERRED', 'settled': true},
    {'date': 'Oct 21, 2023', 'id': '#TXN-9981', 'amount': '\$450.00', 'status': 'PROCESSING', 'settled': false},
    {'date': 'Oct 15, 2023', 'id': '#TXN-9975', 'amount': '\$2,100.00', 'status': 'TRANSFERRED', 'settled': true},
    {'date': 'Oct 02, 2023', 'id': '#TXN-9942', 'amount': '\$890.50', 'status': 'TRANSFERRED', 'settled': true},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ────────────────────────────────────────────
          Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Earnings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Text('Universal Health App', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ])),
            CircleAvatar(radius: 20, backgroundColor: const Color(0xFFE8F5F1), child: const Icon(Icons.person, color: Color(0xFF10B981), size: 22)),
          ]),
          const SizedBox(height: 20),

          // ── Instant Payout Button ──────────────────────────────
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 12, offset: const Offset(0,4))],
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text('Request Instant Payout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
          ),
          const SizedBox(height: 16),

          // ── KPI Cards ─────────────────────────────────────────
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _kpiCard('\$12,450.00', 'Total Revenue', '+12.5%', const Color(0xFF10B981), Icons.monetization_on_outlined),
                const SizedBox(width: 12),
                _kpiCard('\$890.00', 'Pending Payout', 'Due soon', const Color(0xFFF59E0B), Icons.pending_actions_rounded),
                const SizedBox(width: 12),
                _kpiCard('247', 'Orders Fulfilled', 'This month', const Color(0xFF6366F1), Icons.receipt_long_outlined),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Revenue Trends Chart ───────────────────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Revenue Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Last 30 Days', style: TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
              ]),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _monthly.asMap().entries.map((e) {
                    final highlight = e.value >= 0.85;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Container(
                            height: 100 * e.value,
                            decoration: BoxDecoration(
                              color: highlight ? const Color(0xFF10B981) : const Color(0xFFBBF7D0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                for (final label in ['1', '5', '10', '15', '20', '25', '30'])
                  Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              ]),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Recent Payouts ─────────────────────────────────────
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Recent Payouts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 13))),
          ]),
          const SizedBox(height: 10),
          ..._payouts.map((p) => _payoutItem(p)).toList(),
        ]),
      ),
    );
  }

  Widget _kpiCard(String value, String label, String sub, Color color, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text(sub, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))),
        ]),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ]),
    );
  }

  Widget _payoutItem(Map<String, dynamic> p) {
    final settled = p['settled'] as bool;
    final statusColor = settled ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: settled ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
            shape: BoxShape.circle,
          ),
          child: Icon(settled ? Icons.check_circle_outline : Icons.hourglass_empty_rounded, color: statusColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p['date'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
          Text(p['id'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(p['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(p['status'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor))),
        ]),
      ]),
    );
  }
}
