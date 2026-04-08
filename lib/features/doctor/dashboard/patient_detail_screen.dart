import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../patient/controller/patient_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../doctor/controller/doctor_controller.dart';
import '../../doctor/repository/doctor_repository.dart';
import '../../doctor/prescription/e_prescription_pad_view.dart';
import '../../../models/medical_record_model.dart';
import '../../../models/patient_model.dart';
import '../../../models/doctor_model.dart';
import '../../patient/repository/medical_record_repository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PatientDetailScreen extends ConsumerStatefulWidget {
  final String patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  ConsumerState<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final patientId = widget.patientId;
    final userAsync = ref.watch(userDataProvider(patientId));
    final profileAsync = ref.watch(patientProfileProvider(patientId));
    final recordsAsync = ref.watch(patientMedicalRecordsProvider(patientId));
    final doctorAsync = ref.watch(doctorProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading patient: $err')),
        data: (userData) {
          final patientName = userData?['name'] ?? "Patient #${patientId.substring(0, 4)}";
          
          return profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => _buildDetailContent(context, ref, patientName, null, recordsAsync, doctorAsync),
            data: (patient) => _buildDetailContent(context, ref, patientName, patient, recordsAsync, doctorAsync),
          );
        },
      ),
      floatingActionButton: _buildSpeedDial(context, doctorAsync.value),
    );
  }

  Widget _buildSpeedDial(BuildContext context, DoctorModel? doctor) {
    return FloatingActionButton(
      onPressed: () => _showActionSheet(context, doctor),
      backgroundColor: const Color(0xFF10B981),
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }

  void _showActionSheet(BuildContext context, DoctorModel? doctor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text('Clinical Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _actionItem(Icons.medication_outlined, 'New Prescription', const Color(0xFF10B981), () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => EPrescriptionPadView(patientId: widget.patientId))); }),
            _actionItem(Icons.science_outlined, 'Order Lab Test', const Color(0xFF6366F1), () { Navigator.pop(ctx); _showLabOrderDialog(context, doctor); }),
            _actionItem(Icons.monitor_heart_outlined, 'Log Patient Vitals', const Color(0xFFEF4444), () { Navigator.pop(ctx); _showVitalsDialog(context, doctor); }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _actionItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(onTap: onTap, leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)));
  }

  Widget _buildDetailContent(BuildContext context, WidgetRef ref, String name, PatientModel? patient, AsyncValue<List<MedicalRecordModel>> recordsAsync, AsyncValue<DoctorModel?> doctorAsync) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Column(
          children: [
            // ── Premium Header ─────────────────────────────────────
            Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(8, 12, 16, 0), child: Column(children: [
              Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
                const Expanded(child: Center(child: Text('Patient 360°', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
                const Icon(Icons.more_horiz),
              ]),
              const SizedBox(height: 16),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(children: [
                CircleAvatar(radius: 36, backgroundColor: const Color(0xFFE8F5F1), child: Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF10B981)))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  if (patient != null) Row(children: [
                    _chip(Icons.cake_outlined, patient.dateOfBirth ?? 'N/A', const Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    _chip(Icons.water_drop_outlined, patient.bloodGroup ?? 'N/A', const Color(0xFFEF4444)),
                  ]),
                ])),
              ])),
              const SizedBox(height: 8),
              const TabBar(labelColor: Color(0xFF10B981), unselectedLabelColor: Color(0xFF94A3B8), indicatorColor: Color(0xFF10B981), indicatorWeight: 3, tabs: [Tab(text: 'Timeline'), Tab(text: 'Labs'), Tab(text: 'Vitals'), Tab(text: 'Rx')]),
            ])),

            Expanded(
              child: recordsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
                data: (records) {
                  return TabBarView(children: [
                    _TimelineTab(records: records),
                    _LabTab(records: records.where((r) => r.type == 'lab_report' || r.type == 'lab_order').toList()),
                    _VitalsGridTab(records: records.where((r) => r.type == 'vitals').toList(), onEdit: () => _showVitalsDialog(context, doctorAsync.value)),
                    _PrescriptionsTab(records: records.where((r) => r.type == 'prescription').toList()),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLabOrderDialog(BuildContext context, DoctorModel? doctor) {
    if (doctor == null) return;
    final tests = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), title: const Text('Order Lab Tests'), content: TextField(controller: tests, decoration: const InputDecoration(labelText: 'Tests Required')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), ElevatedButton(onPressed: () => _saveRecord(ctx, 'lab_order', 'Lab Requisition', tests.text, doctor), child: const Text('Order'))]));
  }

  void _showVitalsDialog(BuildContext context, DoctorModel? doctor) {
    if (doctor == null) return;
    final bp = TextEditingController();
    final hr = TextEditingController();
    final temp = TextEditingController();
    final spo2 = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Edit Vitals'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _formField(bp, 'Blood Pressure', '120/80'),
        _formField(hr, 'Heart Rate', '72'),
        _formField(temp, 'Temp', '98.6'),
        _formField(spo2, 'SpO2', '98'),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), ElevatedButton(onPressed: () => _saveRecord(ctx, 'vitals', 'Vitals Update', 'BP: ${bp.text}|HR: ${hr.text}|TEMP: ${temp.text}|SPO2: ${spo2.text}', doctor), child: const Text('Save'))],
    ));
  }

  Widget _formField(TextEditingController controller, String label, String hint) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextField(controller: controller, decoration: InputDecoration(labelText: label, hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))));

  Future<void> _saveRecord(BuildContext ctx, String type, String title, String desc, DoctorModel doctor) async {
    final record = MedicalRecordModel(id: const Uuid().v4(), patientId: widget.patientId, doctorId: doctor.id, doctorName: doctor.fullName, type: type, title: title, description: desc, recordDate: DateTime.now(), createdAt: DateTime.now());
    final res = await ref.read(medicalRecordRepositoryProvider).addMedicalRecord(record);
    res.fold((l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${l.message}'))), (r) {
      ref.invalidate(patientMedicalRecordsProvider(widget.patientId));
      Navigator.pop(ctx);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully Updated!'), backgroundColor: Color(0xFF10B981)));
    });
  }

  static Widget _chip(IconData icon, String label, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color))]));
}

class _VitalsGridTab extends StatelessWidget {
  final List<MedicalRecordModel> records;
  final VoidCallback onEdit;
  const _VitalsGridTab({required this.records, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    String bp = 'N/A', hr = 'N/A', temp = 'N/A', spo2 = 'N/A';
    if (records.isNotEmpty) {
      final desc = records.first.description ?? '';
      final parts = desc.split('|');
      for (var p in parts) {
        if (p.startsWith('BP:')) bp = p.replaceFirst('BP:', '').trim();
        if (p.startsWith('HR:')) hr = p.replaceFirst('HR:', '').trim();
        if (p.startsWith('TEMP:')) temp = p.replaceFirst('TEMP:', '').trim();
        if (p.startsWith('SPO2:')) spo2 = p.replaceFirst('SPO2:', '').trim();
      }
    }

    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
      Row(children: [
        Expanded(child: _vitalCard('Blood Pressure', bp, 'mmHg', Icons.monitor_heart_outlined, const Color(0xFF2C6BFF), onEdit)),
        const SizedBox(width: 12),
        Expanded(child: _vitalCard('Heart Rate', hr, 'bpm', Icons.favorite, const Color(0xFFEF4444), onEdit)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _vitalCard('Temperature', temp, '°F', Icons.thermostat, const Color(0xFFF59E0B), onEdit)),
        const SizedBox(width: 12),
        Expanded(child: _vitalCard('Oxygen Sat', spo2, '%', Icons.air, const Color(0xFF10B981), onEdit)),
      ]),
      const SizedBox(height: 24),
      const Align(alignment: Alignment.centerLeft, child: Text('History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      const SizedBox(height: 12),
      ...records.map((r) => _RecordCard(record: r, color: const Color(0xFFEF4444), icon: Icons.history)),
    ]));
  }

  Widget _vitalCard(String label, String value, String unit, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text('$label ($unit)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          const Text('Click to update', style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _TimelineTab extends StatelessWidget {
  final List<MedicalRecordModel> records;
  const _TimelineTab({required this.records});
  @override
  Widget build(BuildContext context) => ListView.builder(padding: const EdgeInsets.all(20), itemCount: records.length, itemBuilder: (_, i) => _RecordCard(record: records[i]));
}

class _LabTab extends StatelessWidget {
  final List<MedicalRecordModel> records;
  const _LabTab({required this.records});
  @override
  Widget build(BuildContext context) => ListView.builder(padding: const EdgeInsets.all(20), itemCount: records.length, itemBuilder: (_, i) => _RecordCard(record: records[i], color: const Color(0xFF6366F1), icon: Icons.science_outlined));
}

class _PrescriptionsTab extends StatelessWidget {
  final List<MedicalRecordModel> records;
  const _PrescriptionsTab({required this.records});
  @override
  Widget build(BuildContext context) => ListView.builder(padding: const EdgeInsets.all(20), itemCount: records.length, itemBuilder: (_, i) => _RecordCard(record: records[i], color: const Color(0xFF10B981), icon: Icons.medication_outlined));
}

class _RecordCard extends StatelessWidget {
  final MedicalRecordModel record;
  final Color color;
  final IconData icon;
  const _RecordCard({required this.record, this.color = const Color(0xFF10B981), this.icon = Icons.description_outlined});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))), const SizedBox(height: 4), Text(record.description ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))), const SizedBox(height: 8), Text(DateFormat('MMM dd, yyyy').format(record.recordDate), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)))])), const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0))]));
}
