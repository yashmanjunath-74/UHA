import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/features/registration/lab/providers/lab_registration_provider.dart';

class LabFacilityDetailsScreen extends ConsumerStatefulWidget {
  const LabFacilityDetailsScreen({super.key});

  @override
  ConsumerState<LabFacilityDetailsScreen> createState() =>
      _LabFacilityDetailsScreenState();
}

class _LabFacilityDetailsScreenState
    extends ConsumerState<LabFacilityDetailsScreen> {
  final _labNameController = TextEditingController();
  final _nablController = TextEditingController();
  final _headOfLabController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with state values if available (for back navigation)
    final state = ref.read(labRegistrationProvider);
    _labNameController.text = state.labName ?? '';
    _nablController.text = state.nablNumber ?? '';
    _headOfLabController.text = state.headOfLab ?? '';
    _selectedCategory = state.category;
  }

  @override
  void dispose() {
    _labNameController.dispose();
    _nablController.dispose();
    _headOfLabController.dispose();
    super.dispose();
  }

  void _onNext() {
    // Update state
    ref
        .read(labRegistrationProvider.notifier)
        .updateField(
          labName: _labNameController.text,
          category: _selectedCategory,
          nablNumber: _nablController.text,
          headOfLab: _headOfLabController.text,
        );

    // Navigate
    ref.read(labRegistrationProvider.notifier).nextStep();
    Navigator.pushNamed(context, '/registration/lab_certifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Facility Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please provide the official details of your laboratory for the UHA registry verification.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Lab Name
                    _buildTextField(
                      label: 'Laboratory Name',
                      controller: _labNameController,
                      hint: 'e.g. Apollo Diagnostics',
                      icon: Icons.biotech,
                    ),
                    const SizedBox(height: 24),

                    // Category
                    _buildDropdown(
                      label: 'Lab Category',
                      value: _selectedCategory,
                      items: [
                        'Pathology',
                        'Radiology',
                        'Diagnostic Center',
                        'Microbiology',
                        'Biochemistry',
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                    ),
                    const SizedBox(height: 24),

                    // NABL Number
                    _buildTextField(
                      label: 'NABL Accreditation No.',
                      controller: _nablController,
                      hint: 'e.g. MC-1234',
                      icon: Icons.verified_user,
                      isUppercase: true,
                      helperText: 'Must match your official certificate ID.',
                      suffixIcon: _nablController.text.isNotEmpty
                          ? Icons.check_circle
                          : null,
                      suffixColor: AppColors.success,
                    ),
                    const SizedBox(height: 24),

                    // Head of Lab
                    _buildTextField(
                      label: 'Head of Lab',
                      controller: _headOfLabController,
                      hint: 'Dr. Full Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 32),

                    // Help Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Need Assistance?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neutral900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "If you don't have your NABL number handy, you can save your progress and return later.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.neutral600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: AppColors.neutral600,
          ),
          const Text(
            'Register Lab',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(width: 40), // Balance spacer
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Step 1 of 3',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Facility Details',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.33,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isUppercase = false,
    String? helperText,
    IconData? suffixIcon,
    Color? suffixColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            textCapitalization: isUppercase
                ? TextCapitalization.characters
                : TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.neutral400),
              prefixIcon: Icon(icon, color: AppColors.neutral400),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: suffixColor)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              helperText,
              style: TextStyle(fontSize: 12, color: AppColors.neutral400),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text(
                'Select Category',
                style: TextStyle(color: AppColors.neutral400),
              ),
              icon: const Icon(Icons.expand_more, color: AppColors.neutral400),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.neutral100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next Step',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
