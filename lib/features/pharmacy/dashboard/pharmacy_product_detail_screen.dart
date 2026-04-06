import 'package:flutter/material.dart';

class PharmacyProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const PharmacyProductDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color itemColor = item['color'] ?? const Color(0xFF10B981);
    final isLowStock = item['stock'] < 50;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(context, itemColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _productHeroCard(isLowStock),
                  const SizedBox(height: 24),
                  _stockManagementCard(),
                  const SizedBox(height: 24),
                  _detailsSections(),
                  const SizedBox(height: 24),
                  const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 12),
                  _activityList(),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _bottomActions(context),
    );
  }

  Widget _sliverAppBar(BuildContext context, Color color) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: color,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.white), onPressed: () {}),
        IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.white), onPressed: () {}),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
            Icon(Icons.medication_rounded, size: 80, color: Colors.white.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }

  Widget _productHeroCard(bool isLowStock) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: Text(item['category'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              ),
              if (isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(10)),
                  child: const Text('LOW STOCK', style: TextStyle(fontSize: 10, color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(item['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          const Text('Manufacturer: Cipla Pharmaceuticals Ltd.', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('UNIT PRICE', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  Text(item['price'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('CURRENT STOCK', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  Text('${item['stock']} Units', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLowStock ? const Color(0xFFEF4444) : const Color(0xFF1E293B))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stockManagementCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Stock Management', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _stockAction(Icons.add, 'Restock', const Color(0xFF10B981))),
              const SizedBox(width: 12),
              Expanded(child: _stockAction(Icons.remove, 'Reduce', const Color(0xFFF59E0B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stockAction(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _detailsSections() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(
        children: [
          _detailRow('Batch Number', 'B-2024-X42', Icons.qr_code_2_rounded),
          _divider(),
          _detailRow('Expiry Date', '12 Nov, 2026', Icons.event_note_rounded),
          _divider(),
          _detailRow('Storage', 'Room Temp (25°C)', Icons.thermostat_rounded),
          _divider(),
          _detailRow('Item Form', 'Capsule / Strip', Icons.medication_outlined),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: const Color(0xFF64748B), size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 45);

  Widget _activityList() {
    final activities = [
      {'title': 'Restocked +50 units', 'date': '24 Oct, 2023', 'type': 'restock'},
      {'title': 'Sold -2 units (Order #10234)', 'date': '24 Oct, 2023', 'type': 'sale'},
      {'title': 'Sold -5 units (Order #10212)', 'date': '23 Oct, 2023', 'type': 'sale'},
    ];

    return Column(
      children: activities.map((a) {
        final isSale = a['type'] == 'sale';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)]),
          child: Row(
            children: [
              CircleAvatar(radius: 18, backgroundColor: isSale ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7), child: Icon(isSale ? Icons.shopping_bag_outlined : Icons.inventory_2_outlined, size: 16, color: isSale ? const Color(0xFFF59E0B) : const Color(0xFF10B981))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
                    Text(a['date']!, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 18),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFF1F5F9)))),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          child: const Text('Update Unit Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}
