import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import '../../patient/controller/patient_controller.dart';
import '../../doctor/controller/doctor_controller.dart';
import '../../../models/medical_record_model.dart';
import 'package:uuid/uuid.dart';

class EPrescriptionPadView extends ConsumerStatefulWidget {
  final String patientId;
  const EPrescriptionPadView({super.key, required this.patientId});

  @override
  ConsumerState<EPrescriptionPadView> createState() => _EPrescriptionPadViewState();
}

class _EPrescriptionPadViewState extends ConsumerState<EPrescriptionPadView> {
  final List<Map<String, String>> _medications = [];
  final _titleController = TextEditingController(text: 'General Prescription');
  final _descController = TextEditingController();

  void _savePrescription() async {
    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one medication')));
      return;
    }

    final doctor = await ref.read(doctorProfileProvider.future);
    if (doctor == null) return;

    final record = MedicalRecordModel(
      id: const Uuid().v4(),
      patientId: widget.patientId,
      doctorId: doctor.id,
      doctorName: doctor.fullName,
      type: 'prescription',
      title: _titleController.text,
      description: _medications.map((m) => "${m['name']} (${m['dosage']})").join("\n"),
      recordDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final res = await ref.read(medicalRecordRepositoryProvider).addMedicalRecord(record);
    
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
      (r) {
        ref.invalidate(patientMedicalRecordsProvider(widget.patientId));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prescription saved successfully!')));
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('E-Rx Pad', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: AppColors.primary, size: 28), 
            onPressed: _savePrescription
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient ID Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  CircleAvatar(radius: 20, backgroundColor: AppColors.primaryLight, child: const Icon(Icons.person, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Prescribing for Patient', style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
                      Text('#${widget.patientId.substring(0, 8)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Diagnosis / Title', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.neutral700)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: 'e.g. Seasonal Flu',
              ),
            ),
            const SizedBox(height: 24),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Medications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
              TextButton.icon(onPressed: _addMedicineDialog, icon: const Icon(Icons.add), label: const Text('Add Medicine')),
            ]),
            const SizedBox(height: 12),

            if (_medications.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.neutral100)),
                child: const Column(children: [
                  Icon(Icons.medication_liquid_outlined, size: 48, color: AppColors.neutral200),
                  SizedBox(height: 12),
                  Text('No medications added yet', style: TextStyle(color: AppColors.neutral400)),
                ]),
              )
            else
              ..._medications.map((m) => _buildMedCard(m)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedCard(Map<String, String> m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withOpacity(0.1))),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(m['dosage']!, style: const TextStyle(color: AppColors.neutral500, fontSize: 13)),
        ])),
        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => setState(() => _medications.remove(m))),
      ]),
    );
  }

  void _addMedicineDialog() {
    String name = '';
    String dosage = '';
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Add Medication'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(onChanged: (v) => name = v, decoration: const InputDecoration(hintText: 'Medicine Name')),
        TextField(onChanged: (v) => dosage = v, decoration: const InputDecoration(hintText: 'Dosage (e.g. 500mg, 1-0-1)')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (name.isNotEmpty && dosage.isNotEmpty) {
            setState(() => _medications.add({'name': name, 'dosage': dosage}));
            Navigator.pop(ctx);
          }
        }, child: const Text('Add')),
      ],
    ));
  }
}
