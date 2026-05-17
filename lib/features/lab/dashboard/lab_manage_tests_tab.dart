import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/lab_controller.dart';

class LabManageTestsTab extends ConsumerStatefulWidget {
  const LabManageTestsTab({super.key});

  @override
  ConsumerState<LabManageTestsTab> createState() => _LabManageTestsTabState();
}

class _LabManageTestsTabState extends ConsumerState<LabManageTestsTab> {
  final _testNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _testNameController.dispose();
    super.dispose();
  }

  void _addTest(String labId, List<String> currentTests) async {
    final testName = _testNameController.text.trim();
    if (testName.isEmpty) return;
    
    debugPrint('Attempting to add test: $testName to lab: $labId');
    
    if (currentTests.contains(testName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test already exists')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final updatedTests = List<String>.from(currentTests)..add(testName);
    
    try {
      await ref.read(labControllerProvider).updateLabTests(labId, updatedTests);
      debugPrint('Update successful for $labId');
      _testNameController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test added successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      debugPrint('Update failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding test: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _removeTest(String labId, List<String> currentTests, String testToRemove) async {
    final updatedTests = List<String>.from(currentTests)..remove(testToRemove);
    
    try {
      await ref.read(labControllerProvider).updateLabTests(labId, updatedTests);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test removed successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing test: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(labProfileProvider);

    return SafeArea(
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No Lab Profile Found'));
          }

          final tests = profile.testTypes;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Lab Tests',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add or remove tests available at your laboratory.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                
                // Add Test Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _testNameController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Complete Blood Count (CBC)',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      _isLoading 
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF10B981))),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add_circle, color: Color(0xFF10B981), size: 28),
                            onPressed: () => _addTest(profile.id, tests),
                          ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                const Text(
                  'Available Tests',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: tests.isEmpty
                      ? const Center(
                          child: Text(
                            'No tests added yet.',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        )
                      : ListView.separated(
                          itemCount: tests.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final testName = tests[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.biotech, color: Color(0xFF10B981), size: 20),
                              ),
                              title: Text(
                                testName,
                                style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF334155)),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Remove Test?'),
                                      content: Text('Are you sure you want to remove "$testName"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _removeTest(profile.id, tests, testName);
                                          },
                                          child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 80), // Padding for bottom nav
              ],
            ),
          );
        },
      ),
    );
  }
}
