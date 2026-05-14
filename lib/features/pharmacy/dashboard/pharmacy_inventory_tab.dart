import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/pharmacy_controller.dart';
import 'pharmacy_product_detail_screen.dart';

class PharmacyInventoryTab extends ConsumerStatefulWidget {
  const PharmacyInventoryTab({super.key});

  @override
  ConsumerState<PharmacyInventoryTab> createState() => _PharmacyInventoryTabState();
}

class _PharmacyInventoryTabState extends ConsumerState<PharmacyInventoryTab> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Antibiotics', 'Analgesics', 'Supplements', 'Acidity', 'Statins'];

  // Controllers for Add Item form
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _batchCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _stockCtrl.dispose();
    _priceCtrl.dispose();
    _batchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(pharmacyInventoryProvider);

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
            child: inventoryAsync.when(
              data: (items) {
                final filteredItems = items.where((item) {
                  if (_selectedCategory != 'All' && item['category'] != _selectedCategory) return false;
                  return true;
                }).toList();

                if (filteredItems.isEmpty) {
                  return const Center(child: Text('No inventory items found.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return _inventoryCard(filteredItems[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
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
    // Generate a consistent color based on category
    final colors = [Color(0xFF10B981), Color(0xFF6366F1), Color(0xFFF59E0B), Color(0xFF8B5CF6), Color(0xFFEC4899)];
    final itemColor = colors[item['category'].hashCode % colors.length];
    
    final stock = int.tryParse(item['stock']?.toString() ?? '0') ?? 0;
    
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
              item['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item['category'] ?? 'General',
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
                    Text('$stock pcs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: stock < 50 ? const Color(0xFFEF4444) : const Color(0xFF1E293B))),
                  ],
                ),
                Text(
                  '₹${item['price'] ?? '0.00'}',
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
    _nameCtrl.clear();
    _categoryCtrl.clear();
    _stockCtrl.clear();
    _priceCtrl.clear();
    _batchCtrl.clear();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            _inputField('Medicine Name', 'e.g. Paracetamol', _nameCtrl),
            const SizedBox(height: 16),
            _inputField('Category', 'e.g. Analgesics', _categoryCtrl),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _inputField('Stock Quantity', '0', _stockCtrl, TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _inputField('Price (₹)', '0.00', _priceCtrl, TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            _inputField('Batch Number', 'e.g. B-2024-X', _batchCtrl),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_nameCtrl.text.isEmpty) return;
                  try {
                    final errorMsg = await ref.read(pharmacyControllerProvider).addInventoryItem({
                      'name': _nameCtrl.text,
                      'category': _categoryCtrl.text.isEmpty ? 'General' : _categoryCtrl.text,
                      'stock': int.tryParse(_stockCtrl.text) ?? 0,
                      'price': double.tryParse(_priceCtrl.text) ?? 0.0,
                      'batch_number': _batchCtrl.text,
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      if (errorMsg != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Saved locally but DB failed: $errorMsg'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully saved to database!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
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

  Widget _inputField(String label, String hint, TextEditingController controller, [TextInputType type = TextInputType.text]) {
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
            controller: controller,
            keyboardType: type,
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
