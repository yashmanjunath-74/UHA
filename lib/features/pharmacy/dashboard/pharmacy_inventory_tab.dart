import 'package:flutter/material.dart';

import 'pharmacy_product_detail_screen.dart';

class PharmacyInventoryTab extends StatefulWidget {
  const PharmacyInventoryTab({super.key});

  @override
  State<PharmacyInventoryTab> createState() => _PharmacyInventoryTabState();
}

class _PharmacyInventoryTabState extends State<PharmacyInventoryTab> {
  final List<Map<String, dynamic>> _inventoryItems = [
    {'name': 'Amoxicillin', 'category': 'Antibiotics', 'stock': 120, 'price': '₹45.00', 'color': Color(0xFF10B981)},
    {'name': 'Paracetamol 650', 'category': 'Analgesics', 'stock': 450, 'price': '₹12.00', 'color': Color(0xFF6366F1)},
    {'name': 'Metformin 500', 'category': 'Antidiabetic', 'stock': 85, 'price': '₹30.00', 'color': Color(0xFFF59E0B)},
    {'name': 'Atorvastatin 20', 'category': 'Statins', 'stock': 60, 'price': '₹55.00', 'color': Color(0xFF8B5CF6)},
    {'name': 'Cetrizine 10', 'category': 'Antihistamine', 'stock': 200, 'price': '₹8.00', 'color': Color(0xFFEC4899)},
    {'name': 'Azithromycin 500', 'category': 'Antibiotics', 'stock': 45, 'price': '₹75.00', 'color': Color(0xFF10B981)},
    {'name': 'Omeprazole 20', 'category': 'Acidity', 'stock': 30, 'price': '₹22.00', 'color': Color(0xFFF43F5E)},
    {'name': 'Vitamin C 500', 'category': 'Supplements', 'stock': 300, 'price': '₹15.00', 'color': Color(0xFF0EA5E9)},
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Antibiotics', 'Analgesics', 'Supplements', 'Acidity', 'Statins'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Search
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Inventory Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    _addButton(context),
                  ],
                ),
                const SizedBox(height: 16),
                _searchBar(),
              ],
            ),
          ),

          // Category Chips
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedCategory == _categories[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = _categories[index]),
                  child: Chip(
                    label: Text(_categories[index]),
                    backgroundColor: isSelected ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Grid View
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _inventoryItems.length,
              itemBuilder: (context, index) {
                final item = _inventoryItems[index];
                if (_selectedCategory != 'All' && item['category'] != _selectedCategory) {
                  return const SizedBox.shrink();
                }
                return _inventoryCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddItemSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.add, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Text(
              'Add Item',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
          hintText: 'Search medicine, batch...',
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _inventoryCard(Map<String, dynamic> item) {
    final Color itemColor = item['color'];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PharmacyProductDetailScreen(item: item)),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medication_outlined, color: itemColor, size: 24),
            ),
            const Spacer(),
            Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item['category'],
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('STOCK', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                    Text('${item['stock']} pcs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: item['stock'] < 50 ? const Color(0xFFEF4444) : const Color(0xFF1E293B))),
                  ],
                ),
                Text(
                  item['price'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF10B981)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Text('Add New Item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 24),
            _inputField('Medicine Name', 'e.g. Paracetamol'),
            const SizedBox(height: 16),
            _inputField('Category', 'e.g. Analgesics'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _inputField('Stock Quantity', '0')),
                const SizedBox(width: 16),
                Expanded(child: _inputField('Price (₹)', '0.00')),
              ],
            ),
            const SizedBox(height: 16),
            _inputField('Batch Number', 'e.g. B-2024-X'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add to Inventory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
