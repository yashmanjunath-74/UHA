import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/features/registration/lab/providers/lab_registration_provider.dart';

class LabCertificationsScreen extends ConsumerStatefulWidget {
  const LabCertificationsScreen({super.key});

  @override
  ConsumerState<LabCertificationsScreen> createState() =>
      _LabCertificationsScreenState();
}

class _LabCertificationsScreenState
    extends ConsumerState<LabCertificationsScreen> {
  final _servicesController = TextEditingController();

  // Simulation of file selection
  String? _nablFileName;
  String? _permitFileName;

  @override
  void initState() {
    super.initState();
    final state = ref.read(labRegistrationProvider);
    _servicesController.text = state.services ?? '';
    _nablFileName = state.nablFilePath != null ? 'nabl_cert.pdf' : null;
    _permitFileName = state.healthPermitFilePath != null
        ? 'health_permit_2024.pdf'
        : null;
  }

  @override
  void dispose() {
    _servicesController.dispose();
    super.dispose();
  }

  void _onNext() {
    ref
        .read(labRegistrationProvider.notifier)
        .updateField(services: _servicesController.text);
    ref.read(labRegistrationProvider.notifier).nextStep();
    Navigator.pushNamed(context, '/registration/lab_bank');
  }

  void _onBack() {
    ref.read(labRegistrationProvider.notifier).previousStep();
    Navigator.pop(context);
  }

  Future<void> _pickFile(String type) async {
    // Simulate file picking
    await ref
        .read(labRegistrationProvider.notifier)
        .uploadFile(
          type,
          type == 'nabl' ? 'path/to/nabl.pdf' : 'path/to/permit.pdf',
        );
    setState(() {
      if (type == 'nabl') {
        _nablFileName = 'nabl_certificate.pdf';
      } else {
        _permitFileName = 'health_permit_2024.pdf';
      }
    });
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
                      'Certifications & Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Verify your lab's credentials by uploading official documents and listing your services.",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Services
                    const Text(
                      'Test Menu / Packages Offered',
                      style: TextStyle(
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
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: TextField(
                        controller: _servicesController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              'e.g., Blood Test, MRI, Full Body Checkup, Thyroid Profile...',
                          hintStyle: TextStyle(color: AppColors.neutral400),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'max 500 chars',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // NABL Upload
                    _buildUploadSection(
                      title: 'NABL / ISO Certification',
                      fileName: _nablFileName,
                      onTap: () => _pickFile('nabl'),
                    ),
                    const SizedBox(height: 24),

                    // Permit Upload
                    _buildUploadSection(
                      title: 'Government Health Permit',
                      fileName: _permitFileName,
                      onTap: () => _pickFile('permit'),
                    ),
                    const SizedBox(height: 24),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.1),
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
                            child: Text(
                              'Certifications must be valid for at least 6 months from the date of registration. Expired documents will be rejected automatically.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary.withOpacity(0.8),
                                height: 1.4,
                              ),
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
            onPressed: _onBack,
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
          const SizedBox(width: 40),
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
                'Step 2 of 3',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Certifications & Services',
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
              widthFactor: 0.66,
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

  Widget _buildUploadSection({
    required String title,
    String? fileName,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: fileName == null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.5),
                      style: BorderStyle
                          .none, // Will implement dashed border painter later or use image
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: AppColors.primary,
                      strokeWidth: 1.5,
                      gap: 5.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cloud_upload_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Tap to upload',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PDF, JPG or PNG (Max 5MB)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Uploaded successfully',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Clear file logic
                        },
                        icon: const Icon(Icons.close),
                        color: AppColors.neutral400,
                      ),
                    ],
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _onBack,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.neutral200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Back',
                style: TextStyle(color: AppColors.neutral700),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
              ),
              child: const Text(
                'Next Step',
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
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;

  DashedRectPainter({
    this.strokeWidth = 2.0,
    this.color = Colors.black,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    _drawDashedLine(path, 0, 0, x, 0); // Top
    _drawDashedLine(path, x, 0, x, y); // Right
    _drawDashedLine(path, x, y, 0, y); // Bottom
    _drawDashedLine(path, 0, y, 0, 0); // Left

    canvas.drawPath(path, dashedPaint);
  }

  void _drawDashedLine(Path path, double x1, double y1, double x2, double y2) {
    double dx = x2 - x1;
    double dy = y2 - y1;
    double length = sqrt(dx * dx + dy * dy);

    if (length == 0) return;

    double ux = dx / length;
    double uy = dy / length;

    double currentLength = 0;
    bool draw = true;

    path.moveTo(x1, y1);

    while (currentLength < length) {
      double dashLength = min(gap, length - currentLength);

      double nextX = x1 + ux * (currentLength + dashLength);
      double nextY = y1 + uy * (currentLength + dashLength);

      if (draw) {
        path.lineTo(nextX, nextY);
      } else {
        path.moveTo(nextX, nextY);
      }

      currentLength += gap;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
