import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/registration_provider.dart';

class Step2Verification extends ConsumerStatefulWidget {
  const Step2Verification({super.key});

  @override
  ConsumerState<Step2Verification> createState() => _Step2VerificationState();
}

class _Step2VerificationState extends ConsumerState<Step2Verification> {
  final _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(registrationProvider);
    _idController.text = state.nationalId;
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _pickIdProof() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(registrationProvider.notifier).updateVerification(proof: image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);
    final notifier = ref.read(registrationProvider.notifier);

    const emeraldGreen = Color(0xFF00A67E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identity Verification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please provide your official identification details to secure your Universal Health account.',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
        ),
        const SizedBox(height: 32),

        // National ID Field
        const Text(
          'National ID / UHID Number',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _idController,
          onChanged: (value) => notifier.updateVerification(nationalId: value),
          decoration: InputDecoration(
            hintText: 'Enter your 12-digit ID',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            suffixIcon: const Icon(Icons.badge_outlined, color: emeraldGreen),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.info_outline, size: 16, color: emeraldGreen),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Found on the front of your government issued ID card.',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // ID Proof Upload
        const Text(
          'Photo of Government ID',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: _pickIdProof,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF9), // Very light green
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: emeraldGreen.withOpacity(0.3),
                style: BorderStyle
                    .none, // Custom dashed border needed essentially, using standard for now
              ),
              // Simulating dashed border with custom painter or just using an image background could work,
              // but for now simple border
            ),
            child: Stack(
              children: [
                // Dashed Border Simulator (Simplified)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DashedBorderPainter(
                      color: emeraldGreen.withOpacity(0.5),
                    ),
                  ),
                ),

                if (state.idProofImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(state.idProofImage!.path),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: emeraldGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tap to upload photo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'SVG, PNG, JPG or PDF\n(max. 800x400px)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: emeraldGreen),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: const Text(
                            'Browse Gallery',
                            style: TextStyle(
                              color: emeraldGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 5.0;
    final path = Path();

    // Top
    double startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, 0);
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }
    // Right
    double startY = 0;
    while (startY < size.height) {
      path.moveTo(size.width, startY);
      path.lineTo(size.width, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }
    // Bottom
    startX = size.width;
    while (startX > 0) {
      path.moveTo(startX, size.height);
      path.lineTo(startX - dashWidth, size.height);
      startX -= dashWidth + dashSpace;
    }
    // Left
    startY = size.height;
    while (startY > 0) {
      path.moveTo(0, startY);
      path.lineTo(0, startY - dashWidth);
      startY -= dashWidth + dashSpace;
    }

    // Create a rounded rect path to clip or just draw rounded logic (simplified here as rect)
    // For rounded dashed border, it's more complex. Using standard rect for speed.
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
