import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/constants/constants.dart';
import '../auth/controller/auth_controller.dart';
import 'controller/admin_controller.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminProvider);

    ref.listen(adminProvider, (previous, next) {
      if (next.error != null && (previous?.error != next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'UHA Admin Portal',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.read(adminProvider.notifier).fetchPendingUsers(),
            icon: const Icon(Icons.refresh, color: Color(0xFF10B981)),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (mounted) {
                Routemaster.of(context).replace(AppConstants.routeLogin);
              }
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF10B981),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF10B981),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Doctors'),
            Tab(text: 'Hospitals'),
            Tab(text: 'Pharmacies'),
            Tab(text: 'Labs'),
          ],
        ),
      ),
      body: adminState.isLoading && adminState.pendingUsers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildUserList('doctor'),
                _buildUserList('hospital'),
                _buildUserList('pharmacy'),
                _buildUserList('lab'),
              ],
            ),
    );
  }

  Widget _buildUserList(String role) {
    final users = ref.watch(adminProvider).pendingUsers.where((u) => u['role'] == role).toList();

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'No pending $role approvals',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildApprovalCard(user);
      },
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF1F5F9),
                radius: 24,
                child: Text(
                  (user['name'] ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'] ?? 'Unknown User',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      user['email'] ?? 'No email provided',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PENDING',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                ),
              ),
            ],
          ),
          
          // Document Viewer Section
          if (_getDocumentUrl(user) != null) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _launchUrl(_getDocumentUrl(user)!),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined, color: Color(0xFF10B981)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'View Registration Document',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                      ),
                    ),
                    const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF64748B)),
                  ],
                ),
              ),
            ),
          ],
          
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(adminProvider.notifier).rejectUser(user['id']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Color(0xFFFFEBEE)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ref.read(adminProvider.notifier).approveUser(user['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Approve Access'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _getDocumentUrl(Map<String, dynamic> user) {
    if (user['hospitals'] == null) return null;
    
    // Supabase can return joined tables as a list if the relation isn't explicitly 1-to-1 singular
    if (user['hospitals'] is List) {
      if ((user['hospitals'] as List).isNotEmpty) {
        return (user['hospitals'] as List).first['document_url'];
      }
    } else if (user['hospitals'] is Map) {
      return user['hospitals']['document_url'];
    }
    return null;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open document')));
      }
    }
  }
}

