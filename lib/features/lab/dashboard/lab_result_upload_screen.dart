import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/core/theme/app_text_styles.dart';

class LabResultUploadScreen extends StatefulWidget {
  const LabResultUploadScreen({super.key});

  @override
  State<LabResultUploadScreen> createState() => _LabResultUploadScreenState();
}

class _LabResultUploadScreenState extends State<LabResultUploadScreen> {
  final _commentController = TextEditingController();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Upload Test Results'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white : AppColors.neutral900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPatientInfoCard(isDark),
              const SizedBox(height: 24),
              Text(
                'Enter Result Data',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 16),
              _buildResultForm(isDark),
              const SizedBox(height: 32),
              _buildUploadSection(isDark),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () {
                          setState(() => _isUploading = true);
                          // Simulate upload delay
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              setState(() => _isUploading = false);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Results uploaded successfully',
                                  ),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            }
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Results',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            foregroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=12',
            ),
            backgroundColor: AppColors.neutral200,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.neutral900,
                  ),
                ),
                Text(
                  'Age: 28 • Male • Blood Group: O+',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultForm(bool isDark) {
    return Column(
      children: [
        _buildTextField(
          isDark,
          label: 'Hemoglobin (g/dL)',
          hint: 'e.g. 14.5',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          isDark,
          label: 'WBC Count (mcL)',
          hint: 'e.g. 5000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          isDark,
          label: 'Platelet Count (mcL)',
          hint: 'e.g. 250000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          isDark,
          label: 'Technician Comments',
          hint: 'Add any observations...',
          maxLines: 3,
          controller: _commentController,
        ),
      ],
    );
  }

  Widget _buildTextField(
    bool isDark, {
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.neutral300 : AppColors.neutral700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : AppColors.neutral900),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.neutral600 : AppColors.neutral400,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E1E1E) : AppColors.neutral50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.neutral50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload Report PDF',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drag & drop or click to browse',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
