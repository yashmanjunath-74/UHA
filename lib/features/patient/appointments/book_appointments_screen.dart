import 'package:flutter/material.dart';
import 'doctor_detail_screen.dart';

class BookAppointmentsScreen extends StatelessWidget {
  const BookAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    _buildCategoriesSection(),
                    const SizedBox(height: 32),
                    _buildTopDoctorsSection(context),
                    const SizedBox(height: 120), // Spacer for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find your',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              Text(
                'Specialist Doctor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.filter_list_rounded, color: Color(0xFF10B981)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search doctor or category...',
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Cardiology', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFEF4444)},
      {'name': 'Pediatrics', 'icon': Icons.child_care_rounded, 'color': const Color(0xFF3B82F6)},
      {'name': 'Dental', 'icon': Icons.medical_services_rounded, 'color': const Color(0xFFF59E0B)},
      {'name': 'Eye Care', 'icon': Icons.visibility_rounded, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Dermatology', 'icon': Icons.clean_hands_rounded, 'color': const Color(0xFF10B981)},
      {'name': 'Orthopedic', 'icon': Icons.accessibility_new_rounded, 'color': const Color(0xFF6366F1)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final cat = categories[i];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorSearchListScreen(title: cat['name'] as String),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (cat['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        color: cat['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['name'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopDoctorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Doctors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorSearchListScreen(title: 'All Doctors'),
                  ),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            return _buildDoctorCard(context);
          },
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC9s6caATreQl8lsqAZ4Sjxbij1sV7DWXDvUl-UjBxweezGFPEvyMVvBKwE1Yh7X7mtGHm55kZg8MlRA_8oA27IaqAyDiA3amZbofK4jS4fw3GWCkcEfJfohcKRDYN4-E9_7WnbrQtDiD9OrPnWj1L1kvF9xLV9ACsmoS0ncXpF_YThCZK29KVSV8JcqYpVr-wtt7RP1LJtL92RQHKuCjcC_jiPyzkyHM2YwHdOMKFX1AzzA3tHzwBOJJDfE9QX2ibUYewYFI3dvNUR',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, color: Colors.red, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Dr. Tasim Jara',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Color(0xFF10B981), size: 18),
                      ],
                    ),
                    const Text('City Heart Hospital', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                        const SizedBox(width: 4),
                        const Text('4.9', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const SizedBox(width: 12),
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        const Text('Available Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat('EXPERIENCE', '12 Years'),
              _buildSimpleStat('PATIENTS', '2.5k+'),
              _buildSimpleStat('REVIEWS', '1.8k'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorDetailScreen(
                      name: 'Dr. Tasim Jara',
                      specialty: 'Cardiologist • Apollo Hospital',
                      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC9s6caATreQl8lsqAZ4Sjxbij1sV7DWXDvUl-UjBxweezGFPEvyMVvBKwE1Yh7X7mtGHm55kZg8MlRA_8oA27IaqAyDiA3amZbofK4jS4fw3GWCkcEfJfohcKRDYN4-E9_7WnbrQtDiD9OrPnWj1L1kvF9xLV9ACsmoS0ncXpF_YThCZK29KVSV8JcqYpVr-wtt7RP1LJtL92RQHKuCjcC_jiPyzkyHM2YwHdOMKFX1AzzA3tHzwBOJJDfE9QX2ibUYewYFI3dvNUR',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF064E3B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text('Book Appointment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      ],
    );
  }
}

class DoctorSearchListScreen extends StatelessWidget {
  final String title;
  const DoctorSearchListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.chevron_left, color: Color(0xFF0F172A)), onPressed: () => Navigator.pop(context)),
        title: Text(title, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.tune, color: Color(0xFF64748B)), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Found 48 doctors near you', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 4),
          Text('$title\nin your area', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Available Today', true, Icons.calendar_today),
                const SizedBox(width: 12),
                _filterChip('5 Stars', false, Icons.star_rounded),
                const SizedBox(width: 12),
                _filterChip('Nearby', false, Icons.near_me_outlined),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const BookAppointmentsScreen()._buildDoctorCard(context),
          const SizedBox(height: 16),
          const BookAppointmentsScreen()._buildDoctorCard(context),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isActive, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? null : Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isActive ? Colors.white : const Color(0xFF10B981)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.white : const Color(0xFF475569))),
        ],
      ),
    );
  }
}
