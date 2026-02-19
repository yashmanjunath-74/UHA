import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/core/theme/app_text_styles.dart';
import 'package:unified_health_alliance/features/pharmacy/providers/pharmacy_provider.dart';

class PharmacyOrderQueue extends ConsumerStatefulWidget {
  const PharmacyOrderQueue({super.key});

  @override
  ConsumerState<PharmacyOrderQueue> createState() => _PharmacyOrderQueueState();
}

class _PharmacyOrderQueueState extends ConsumerState<PharmacyOrderQueue> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pharmacyState = ref.watch(pharmacyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prescription Queue',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.neutral900,
              ),
            ),
            Text(
              'Universal Health Pharmacy #42',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.primary,
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.neutral900,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search orders...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.neutral400,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.backgroundDark
                              : AppColors.neutral50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list),
                        color: AppColors.primary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'All Orders',
                        pharmacyState.selectedFilter == 'All Orders',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'New',
                        pharmacyState.selectedFilter == 'New',
                        count: 3,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Preparing',
                        pharmacyState.selectedFilter == 'Preparing',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Ready',
                        pharmacyState.selectedFilter == 'Ready',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pharmacyState.orders.length,
        itemBuilder: (context, index) {
          final order = pharmacyState.orders[index];
          // Filter logic
          if (pharmacyState.selectedFilter != 'All Orders' &&
              order.status != pharmacyState.selectedFilter) {
            return const SizedBox.shrink();
          }

          return _buildOrderCard(context, order, isDark);
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {int? count}) {
    return GestureDetector(
      onTap: () {
        ref.read(pharmacyProvider.notifier).setFilter(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutral200,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.neutral600,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    PharmacyOrder order,
    bool isDark,
  ) {
    Color statusColor;
    Color statusBgColor;

    switch (order.status) {
      case 'New':
        statusColor = AppColors.primary;
        statusBgColor = AppColors.primary.withOpacity(0.1);
        break;
      case 'Preparing':
        statusColor = AppColors.warning;
        statusBgColor = AppColors.warning.withOpacity(0.1);
        break;
      case 'Ready':
        statusColor = AppColors.secondary;
        statusBgColor = AppColors.secondary.withOpacity(0.1);
        break;
      default:
        statusColor = AppColors.neutral500;
        statusBgColor = AppColors.neutral100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: statusColor, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${order.id}',
                          style: TextStyle(
                            fontFamily: 'Monospace',
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      order.time,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  order.patientName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.medication,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: order.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.name} ${item.dosage}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.neutral800,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item.quantity} • ${item.instructions}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.neutral400
                                          : AppColors.neutral500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Print Label'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.neutral300
                          : AppColors.neutral600,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.neutral700
                            : AppColors.neutral300,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pharmacy/fulfillment');
                    },
                    icon: const Icon(Icons.update, size: 18),
                    label: const Text('Update Status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
