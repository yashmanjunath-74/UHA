# Patient Registration Implementation Guide

This file shows how to integrate patient registration in your UI screens.

---

## 1. Complete Example: Registration Screen with Backend Integration

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PatientRegistrationScreen extends ConsumerStatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  ConsumerState<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState
    extends ConsumerState<PatientRegistrationScreen> {
  late TextEditingController _dateOfBirthController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _allergiesController;
  late TextEditingController _chronicConditionsController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactPhoneController;

  String? _selectedGender;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _dateOfBirthController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _allergiesController = TextEditingController();
    _chronicConditionsController = TextEditingController();
    _emergencyContactNameController = TextEditingController();
    _emergencyContactPhoneController = TextEditingController();
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _chronicConditionsController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _registerPatient() async {
    // Validate inputs
    if (_selectedGender == null ||
        _dateOfBirthController.text.isEmpty ||
        _bloodGroupController.text.isEmpty ||
        _emergencyContactNameController.text.isEmpty ||
        _emergencyContactPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Registering patient...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      // Parse allergies and chronic conditions (comma-separated)
      final allergies = _allergiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final chronicConditions = _chronicConditionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Call registration
      final notifier = ref.read(patientRegistrationProvider.notifier);
      await notifier.registerPatient(
        userId: user.id,
        dateOfBirth: _dateOfBirthController.text,
        gender: _selectedGender!,
        bloodGroup: _bloodGroupController.text,
        allergies: allergies,
        chronicConditions: chronicConditions,
        emergencyContactName: _emergencyContactNameController.text,
        emergencyContactPhone: _emergencyContactPhoneController.text,
      );

      // Navigate to success screen
      Navigator.pop(context); // Close loading dialog
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/patient-home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Patient Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date of Birth
            const Text('Date of Birth *'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDateOfBirth,
              child: TextField(
                controller: _dateOfBirthController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select date of birth',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            const Text('Gender *'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: _genderOptions.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedGender = value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Select gender',
              ),
            ),
            const SizedBox(height: 16),

            // Blood Group
            const Text('Blood Group *'),
            const SizedBox(height: 8),
            TextField(
              controller: _bloodGroupController,
              decoration: InputDecoration(
                hintText: 'E.g., O+, A-, AB+',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Allergies
            const Text('Allergies (comma-separated)'),
            const SizedBox(height: 8),
            TextField(
              controller: _allergiesController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'E.g., Penicillin, Sulfa drugs',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chronic Conditions
            const Text('Chronic Conditions (comma-separated)'),
            const SizedBox(height: 8),
            TextField(
              controller: _chronicConditionsController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'E.g., Diabetes, Hypertension',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Contact Name
            const Text('Emergency Contact Name *'),
            const SizedBox(height: 8),
            TextField(
              controller: _emergencyContactNameController,
              decoration: InputDecoration(
                hintText: 'Enter contact name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Contact Phone
            const Text('Emergency Contact Phone *'),
            const SizedBox(height: 8),
            TextField(
              controller: _emergencyContactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerPatient,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Complete Registration',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 2. Using Patient Service in Widgets

```dart
// Simple example using PatientService
class PatientProfileWidget extends ConsumerWidget {
  final String userId;

  const PatientProfileWidget({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(patientProfileProvider(userId));

    return profileAsync.when(
      data: (patient) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Date of Birth'),
            subtitle: Text(patient.dateOfBirth ?? 'Not set'),
          ),
          ListTile(
            title: const Text('Gender'),
            subtitle: Text(patient.gender?.name ?? 'Not set'),
          ),
          ListTile(
            title: const Text('Blood Group'),
            subtitle: Text(patient.bloodGroup ?? 'Not set'),
          ),
          ListTile(
            title: const Text('Allergies'),
            subtitle: Text(
              patient.allergies.isEmpty
                  ? 'None recorded'
                  : patient.allergies.join(', '),
            ),
          ),
          ListTile(
            title: const Text('Emergency Contact'),
            subtitle: Text(
              patient.emergencyContactName ?? 'Not set',
            ),
            trailing: Text(patient.emergencyContactPhone ?? ''),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
    );
  }
}
```

---

## 3. Checking if Patient Has Completed Profile

```dart
// Check registration status before navigating
class PatientStatusCheck extends ConsumerWidget {
  const PatientStatusCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return FutureBuilder<bool>(
      future: _checkPatientRegistration(ref, user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          // Patient has completed registration
          return PatientHomeScreen(userId: user.id);
        } else {
          // Patient needs to complete registration
          return const PatientRegistrationScreen();
        }
      },
    );
  }

  Future<bool> _checkPatientRegistration(WidgetRef ref, String userId) async {
    final repository = ref.read(patientRepositoryProvider);
    final result = await repository.patientExists(userId);

    return result.fold(
      (failure) => false,
      (exists) => exists,
    );
  }
}
```

---

## 4. Handling Registration Errors

```dart
// Watch registration state with error handling
class PatientRegistrationForm extends ConsumerWidget {
  const PatientRegistrationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(patientRegistrationProvider);

    return registrationState.when(
      data: (patient) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text('Registration Complete!'),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text('Error: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retry logic
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 5. Integration with Your Existing Registration Flow

Add this to your registration completion:

```dart
// After user completes basic info, verify email, and selects role
Future<void> completeRegistration(WidgetRef ref) async {
  final user = Supabase.instance.client.auth.currentUser;

  // 1. Update user role in users table (if not done in trigger)
  await ref.read(supabaseClientProvider)
      .from('users')
      .update({'role': 'patient'})
      .eq('id', user!.id);

  // 2. Register patient profile
  final notifier = ref.read(patientRegistrationProvider.notifier);
  await notifier.registerPatient(
    userId: user.id,
    dateOfBirth: dob,
    gender: gender,
    bloodGroup: bloodGroup,
    allergies: allergies,
    chronicConditions: chronicConditions,
    emergencyContactName: contactName,
    emergencyContactPhone: contactPhone,
  );

  // 3. Navigate to home
  // Navigator.pushReplacementNamed(context, '/patient-home');
}
```

---

## Summary

- **`PatientRepository`**: Low-level database operations
- **`PatientController`**: Riverpod providers and state management
- **`PatientService`**: High-level API with validation
- **UI Integration**: Use the examples above in your screens

All code is error-handled and follows your project's FP-Dart pattern!
