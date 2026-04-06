import 'package:flutter/material.dart';

class LabEarningsTab extends StatelessWidget {
  const LabEarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Earnings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const Text('City Diagnostics Lab Summary', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const SizedBox(height: 24),

          // Total Revenue Card
          _revenueCard(),
          const SizedBox(height: 24),

          // KPI Row
          Row(children: [
            _kpiCard('₹2,45,000', 'Total Revenue', '+12.5%', const Color(0xFF10B981)),
            const SizedBox(width: 12),
            _kpiCard('840', 'Tests Processed', 'This Month', const Color(0xFF6366F1)),
          ]),
          const SizedBox(height: 24),

          // Revenue Chart (Placeholder Bar Chart)
          _revenueTrend(),
          const SizedBox(height: 24),

          // Recent Payouts
          const Text('Recent Payouts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          _payoutItem('Oct 21, 2023', '₹45,000.00', 'TRANSFERRED', const Color(0xFF10B981)),
          const SizedBox(height: 10),
          _payoutItem('Oct 14, 2023', '₹38,200.00', 'TRANSFERRED', const Color(0xFF10B981)),
          const SizedBox(height: 10),
          _payoutItem('Oct 07, 2023', '₹41,500.00', 'PROCESSING', const Color(0xFFF59E0B)),
        ]),
      ),
    );
  }

  Widget _revenueCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Available for Payout', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          const Text('₹8,900.25', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Request Instant Payout', style: TextStyle(fontWeight: FontWeight.bold))),
        ]),
      );

  Widget _kpiCard(String value, String label, String sub, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.show_chart_rounded, color: color, size: 18)),
              Text(sub, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
            ]),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ]),
        ),
      );

  Widget _revenueTrend() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Revenue Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const Text('Last 30 Days', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          ]),
          const SizedBox(height: 24),
          SizedBox(height: 120, child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(12, (i) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Container(height: (40 + (i * 10 % 80)).toDouble(), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.3 + (i / 20)), borderRadius: BorderRadius.circular(4)))))))),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ['Oct 1', 'Oct 15', 'Oct 30'].map((d) => Text(d, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)))).toList()),
        ]),
      );

  Widget _payoutItem(String date, String amount, String status, Color color) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.check_circle_outline_rounded, color: color, size: 20)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
            Text('Payout ID: #TXN-42291', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
            Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ]),
        ]),
      );
}
