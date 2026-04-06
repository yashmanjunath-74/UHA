import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:io';
import '../../../core/constants/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/common/custom_text_field.dart';
import '../../../core/common/primary_button.dart';
import 'hospital_registration_provider.dart';

class HospitalProfileScreen extends ConsumerStatefulWidget {
  const HospitalProfileScreen({super.key});

  @override
  ConsumerState<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends ConsumerState<HospitalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedType = 'General Hospital';
  File? _selectedDocument;

  final List<String> _institutionTypes = [
    'General Hospital',
    'Specialty Clinic',
    'Medical Center',
    'Nursing Home',
    'Diagnostic Center',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill if already set in state
    final state = ref.read(hospitalRegProvider);
    _nameController.text = state.institutionName;
    _contactController.text = state.contactNumber;
    _emailController.text = state.officialEmail;
    _selectedType = state.institutionType;
    _selectedDocument = state.registrationDocument;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedDocument = File(result.files.single.path!);
      });
    }
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDocument == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a registration document'), backgroundColor: Colors.red),
        );
        return;
      }
      ref.read(hospitalRegProvider.notifier).updateProfile(
            institutionName: _nameController.text,
            institutionType: _selectedType,
            contactNumber: _contactController.text,
            officialEmail: _emailController.text,
            document: _selectedDocument,
          );
      Routemaster.of(context).push(AppConstants.routeRegHospitalInfra);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : Colors.grey[100], shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.neutral600, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Text('Registration', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.neutral400 : AppColors.neutral500, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Step 1 of 3', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                        Text('33% Completed', style: TextStyle(color: isDark ? AppColors.neutral400 : AppColors.neutral500, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: 0.33, backgroundColor: isDark ? AppColors.surfaceDark : AppColors.neutral200, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 8),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text('Institution Profile', style: AppTextStyles.displayMedium.copyWith(color: isDark ? Colors.white : AppColors.neutral900, fontSize: 28)),
                    const SizedBox(height: 8),
                    Text("Basic details about your healthcare facility.", style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.neutral400 : AppColors.neutral500)),
                    const SizedBox(height: 32),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Institution Name
                          CustomTextField(controller: _nameController, label: 'Institution Name', hint: 'City General Hospital', prefixIcon: Icons.business_outlined, validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 20),

                          // Institution Type
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text('Institution Type', style: AppTextStyles.labelMedium.copyWith(color: isDark ? AppColors.neutral300 : AppColors.neutral700))),
                              Container(
                                decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral200)),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedType,
                                    isExpanded: true,
                                    dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                    items: _institutionTypes.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: isDark ? Colors.white : AppColors.neutral900)))).toList(),
                                    onChanged: (newValue) => setState(() => _selectedType = newValue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Contact Number
                          CustomTextField(controller: _contactController, label: 'Contact Number', hint: '+1 (555) 000-0000', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 20),

                          // Email
                          CustomTextField(controller: _emailController, label: 'Official Email', hint: 'admin@hospital.com', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 24),

                          // Document Upload
                          Text('Registration Document / License', style: AppTextStyles.labelMedium.copyWith(color: isDark ? AppColors.neutral300 : AppColors.neutral700)),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _pickDocument,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral300, style: BorderStyle.solid),
                              ),
                              child: Column(
                                children: [
                                  Icon(_selectedDocument == null ? Icons.upload_file : Icons.check_circle, size: 40, color: _selectedDocument == null ? AppColors.primary : Colors.green),
                                  const SizedBox(height: 12),
                                  Text(
                                    _selectedDocument == null ? 'Tap to upload document (PDF/Image)' : 'Document Selected',
                                    style: TextStyle(color: isDark ? AppColors.neutral400 : AppColors.neutral600),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(text: 'Next Step', onPressed: _nextStep, icon: Icons.arrow_forward_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
