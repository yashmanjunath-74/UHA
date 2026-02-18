import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../providers/registration_provider.dart';

class Step1BasicInfo extends ConsumerStatefulWidget {
  const Step1BasicInfo({super.key});

  @override
  ConsumerState<Step1BasicInfo> createState() => _Step1BasicInfoState();
}

class _Step1BasicInfoState extends ConsumerState<Step1BasicInfo> {
  final _nameController = TextEditingController();
  final _dateFormat = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    super.initState();
    // Pre-fill if data exists
    final state = ref.read(registrationProvider);
    if (state.firstName.isNotEmpty) {
      _nameController.text = '${state.firstName} ${state.lastName}'.trim();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(registrationProvider.notifier).updateBasicInfo(photo: image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);
    final notifier = ref.read(registrationProvider.notifier);

    // Custom Colors
    const emeraldGreen = Color(0xFF00A67E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please provide your basic information to set up your patient profile.',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
        ),
        const SizedBox(height: 32),

        // Photo Upload
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: emeraldGreen.withOpacity(0.5),
                      width: 2,
                      style: BorderStyle
                          .solid, // Dashed is hard in standard border, using solid for now
                    ),
                    image: state.profilePhoto != null
                        ? DecorationImage(
                            image: FileImage(File(state.profilePhoto!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: state.profilePhoto == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: emeraldGreen,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                color: emeraldGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Full Name
        const Text(
          'Full Name',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          onChanged: (value) {
            final parts = value.trim().split(' ');
            if (parts.isNotEmpty) {
              notifier.updateBasicInfo(
                firstName: parts.first,
                lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
              );
            }
          },
          decoration: InputDecoration(
            hintText: 'Jane Doe',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xFF9CA3AF),
            ),
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
        const SizedBox(height: 24),

        // Date of Birth
        const Text(
          'Date of Birth',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              notifier.updateBasicInfo(dob: date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  state.dateOfBirth != null
                      ? _dateFormat.format(state.dateOfBirth!)
                      : 'MM/DD/YYYY',
                  style: TextStyle(
                    color: state.dateOfBirth != null
                        ? const Color(0xFF111827)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Gender
        const Text(
          'Gender',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _GenderCard(
              label: 'Male',
              icon: Icons.male,
              isSelected: state.gender == 'Male',
              onTap: () => notifier.updateBasicInfo(gender: 'Male'),
            ),
            const SizedBox(width: 12),
            _GenderCard(
              label: 'Female',
              icon: Icons.female,
              isSelected: state.gender == 'Female',
              onTap: () => notifier.updateBasicInfo(gender: 'Female'),
            ),
            const SizedBox(width: 12),
            _GenderCard(
              label: 'Other',
              icon: Icons.transgender,
              isSelected: state.gender == 'Other',
              onTap: () => notifier.updateBasicInfo(gender: 'Other'),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const emeraldGreen = Color(0xFF00A67E);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? emeraldGreen.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? emeraldGreen : const Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? emeraldGreen : const Color(0xFF6B7280),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? emeraldGreen : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
