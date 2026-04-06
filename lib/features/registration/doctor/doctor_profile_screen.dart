import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/app_colors.dart';
import 'doctor_reg_provider.dart';

// ════════════════════════════════════════════════════════════
// STEP 1 — Professional Profile
// ════════════════════════════════════════════════════════════
class DoctorProfileScreen extends ConsumerStatefulWidget {
  const DoctorProfileScreen({super.key});
  @override ConsumerState<DoctorProfileScreen> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends ConsumerState<DoctorProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _qualCtrl = TextEditingController();
  int _yearsOfExp = 5;
  String? _specialty;

  final _specialties = ['Cardiology','Dermatology','ENT','General Practice','Gynecology','Neurology','Oncology','Orthopedics','Pediatrics','Psychiatry','Radiology','Urology'];

  @override void dispose() { _nameCtrl.dispose(); _licenseCtrl.dispose(); _qualCtrl.dispose(); super.dispose(); }

  Future<void> _pickDoc() async {
    final r = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf','jpg','jpeg','png']);
    if (r?.files.single.path != null) ref.read(doctorRegProvider.notifier).setDocument(File(r!.files.single.path!));
  }

  void _next() {
    if (_nameCtrl.text.trim().isEmpty || _licenseCtrl.text.trim().isEmpty || _qualCtrl.text.trim().isEmpty) {
      _snack('Please fill all required fields'); return;
    }
    if (_specialty == null) { _snack('Please select a specialty'); return; }
    ref.read(doctorRegProvider.notifier).setStep1(_nameCtrl.text.trim(), _specialty!, _licenseCtrl.text.trim(), _qualCtrl.text.trim(), _yearsOfExp);
    Routemaster.of(context).push(AppConstants.routeRegDoctorCredentials);
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));

  @override
  Widget build(BuildContext context) {
    final doc = ref.watch(doctorRegProvider).document;
    return _Shell(
      step: 'Step 1 of 3', title: 'Doctor Registration', progress: 0.33, onNext: _next,
      heading: 'Professional Profile', subtitle: "Verify your medical credentials to get started.",
      child: Column(children: [
        _inp(_nameCtrl, 'Full Name *', 'Dr. John Smith', Icons.person_outline),
        const SizedBox(height: 14),
        _drop('Specialization *', _specialty, _specialties, (v) => setState(() => _specialty = v)),
        const SizedBox(height: 14),
        _inp(_licenseCtrl, 'Medical License Number *', 'MCI-12345678', Icons.badge_outlined),
        const SizedBox(height: 14),
        _inp(_qualCtrl, 'Qualification (MBBS, MD…) *', 'MBBS, MD', Icons.school_outlined),
        const SizedBox(height: 14),
        _counter('Years of Experience', _yearsOfExp, () { if (_yearsOfExp > 0) setState(() => _yearsOfExp--); }, () => setState(()=>_yearsOfExp++)),
        const SizedBox(height: 20),
        _docPick(doc, _pickDoc),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
// STEP 2 — Hospital Affiliation
// ════════════════════════════════════════════════════════════
class DoctorCredentialsScreen extends ConsumerStatefulWidget {
  const DoctorCredentialsScreen({super.key});
  @override ConsumerState<DoctorCredentialsScreen> createState() => _DoctorCredState();
}

class _DoctorCredState extends ConsumerState<DoctorCredentialsScreen> {
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override void initState() { super.initState(); Future.microtask(()=>ref.read(doctorRegProvider.notifier).loadHospitals()); }
  @override void dispose() { _phoneCtrl.dispose(); _addressCtrl.dispose(); super.dispose(); }

  void _next() {
    if (_phoneCtrl.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your work phone'), backgroundColor: Colors.red)); return; }
    final s = ref.read(doctorRegProvider);
    if (!s.isIndependent && s.selectedHospitalIds.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one hospital or mark as independent'), backgroundColor: Colors.red)); return; }
    ref.read(doctorRegProvider.notifier).setStep2(_phoneCtrl.text.trim(), _addressCtrl.text.trim());
    Routemaster.of(context).push(AppConstants.routeRegDoctorSecurity);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(doctorRegProvider);
    return _Shell(
      step: 'Step 2 of 3', title: 'Doctor Registration', progress: 0.66, onNext: _next,
      heading: 'Hospital Affiliation', subtitle: 'Select hospitals you belong to, or mark as independent.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Independent switch
        _toggleCard('Independent Practitioner', Icons.person_pin_rounded, const Color(0xFF6366F1),
          'Not affiliated with any hospital', s.isIndependent,
          (v) => ref.read(doctorRegProvider.notifier).setIndependent(v)),
        if (!s.isIndependent) ...[
          const SizedBox(height: 20),
          const Text('Affiliated Hospitals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          const Text('Tap to select (multi-select supported)', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 12),
          if (s.hospitals.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primary)))
          else
            ...s.hospitals.map((h) {
              final selected = s.selectedHospitalIds.contains(h['id']);
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: _checkHospitalTile(h, selected, ()=>ref.read(doctorRegProvider.notifier).toggleHospital(h['id'])));
            }),
        ],
        const SizedBox(height: 20),
        _inp(_phoneCtrl, 'Work Phone *', '+91 9876543210', Icons.phone_outlined, type: TextInputType.phone),
        const SizedBox(height: 14),
        _inp(_addressCtrl, 'Clinic Address (Optional)', '123 Medical Road', Icons.location_on_outlined),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
// STEP 3 — Account Setup
// ════════════════════════════════════════════════════════════
class DoctorSecurityScreen extends ConsumerStatefulWidget {
  const DoctorSecurityScreen({super.key});
  @override ConsumerState<DoctorSecurityScreen> createState() => _DoctorSecurityState();
}

class _DoctorSecurityState extends ConsumerState<DoctorSecurityScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  @override void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red)); return;
    }
    ref.read(doctorRegProvider.notifier).setAccount(_emailCtrl.text.trim(), _passCtrl.text, _confirmCtrl.text);
    await ref.read(doctorRegProvider.notifier).submit();
    final s = ref.read(doctorRegProvider);
    if (s.error != null && mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.error!), backgroundColor: Colors.red)); return; }
    if (s.isSuccess && mounted) Routemaster.of(context).replace(AppConstants.routeWaitingApproval);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(doctorRegProvider);
    return _Shell(
      step: 'Step 3 of 3', title: 'Doctor Registration', progress: 1.0,
      onNext: s.isLoading ? null : _submit, nextLabel: s.isLoading ? 'Submitting…' : 'Submit Registration', isLoading: s.isLoading,
      heading: 'Account Setup', subtitle: 'Create your UHA login credentials.',
      child: Column(children: [
        _inp(_emailCtrl, 'Email Address *', 'doctor@example.com', Icons.email_outlined, type: TextInputType.emailAddress),
        const SizedBox(height: 14),
        _inpObs(_passCtrl, 'Password *', '••••••••', _obscure, ()=>setState(()=>_obscure=!_obscure)),
        const SizedBox(height: 14),
        _inpObs(_confirmCtrl, 'Confirm Password *', '••••••••', true, null),
        const SizedBox(height: 20),
        _infoBox('Your account will be reviewed by UHA Admin before access is granted.'),
        if (s.error != null) ...[const SizedBox(height: 10), Text(s.error!, style: const TextStyle(color: Colors.red, fontSize: 13))],
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SHARED SHELL
// ═══════════════════════════════════════════════════════════
class _Shell extends StatelessWidget {
  final String step, title, heading, subtitle;
  final double progress;
  final Widget child;
  final VoidCallback? onNext;
  final String nextLabel;
  final bool isLoading;
  const _Shell({required this.step, required this.title, required this.progress, required this.heading, required this.subtitle, required this.child, this.onNext, this.nextLabel='Next Step →', this.isLoading=false});

  @override Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.white, body: SafeArea(child: Column(children: [
    Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(4,16,16,12), child: Column(children: [
      Row(children: [
        IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)), onPressed: ()=>Routemaster.of(context).pop()),
        const Spacer(),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF64748B))),
        const Spacer(),
        Text(step, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 6, color: AppColors.primary, backgroundColor: const Color(0xFFE2E8F0))),
    ])),
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(heading, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
      const SizedBox(height: 24),
      child,
    ]))),
    Container(padding: const EdgeInsets.fromLTRB(24,12,24,24), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFF1F5F9)))),
      child: SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
        onPressed: onNext,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, disabledBackgroundColor: AppColors.primary.withOpacity(0.5), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
        child: isLoading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : Text(nextLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ))),
  ])));
}

// ═══════════════════════════════════════════════════════════
// SHARED HELPER WIDGETS
// ═══════════════════════════════════════════════════════════
Widget _inp(TextEditingController c, String label, String hint, IconData icon, {TextInputType? type}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
    const SizedBox(height: 6),
    TextField(controller: c, keyboardType: type, decoration: _dec(hint, icon)),
  ]);
}

Widget _inpObs(TextEditingController c, String label, String hint, bool obs, VoidCallback? toggle) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
    const SizedBox(height: 6),
    TextField(controller: c, obscureText: obs, decoration: _dec(hint, Icons.lock_outline, suffix: toggle != null ? IconButton(icon: Icon(obs?Icons.visibility_off:Icons.visibility, size: 20, color: Colors.grey), onPressed: toggle) : null)),
  ]);
}

InputDecoration _dec(String hint, IconData icon, {Widget? suffix}) => InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14), prefixIcon: Icon(icon, size: 20, color: const Color(0xFF9CA3AF)), suffixIcon: suffix, filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)), contentPadding: const EdgeInsets.symmetric(vertical: 14));

Widget _drop(String label, String? value, List<String> items, void Function(String?) onChanged) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
    const SizedBox(height: 6),
    Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, hint: const Text('Select…', style: TextStyle(color: Color(0xFF9CA3AF), fontSize:14)), onChanged: onChanged, items: items.map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), icon: const Icon(Icons.expand_more, color: Color(0xFF64748B))))),
  ]);
}

Widget _counter(String label, int value, VoidCallback dec, VoidCallback inc) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
    const SizedBox(height: 6),
    Container(decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(children: [
        InkWell(onTap: dec, child: const SizedBox(width: 48, height: 52, child: Icon(Icons.remove, color: Color(0xFF64748B), size: 20))),
        Expanded(child: Center(child: Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))))),
        InkWell(onTap: inc, child: const SizedBox(width: 48, height: 52, child: Icon(Icons.add, color: Color(0xFF64748B), size: 20))),
      ])),
  ]);
}

Widget _docPick(File? doc, VoidCallback onTap) {
  return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: doc!=null?AppColors.primary:const Color(0xFFE2E8F0), width: 1.5)),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(doc!=null?Icons.check_circle:Icons.upload_file_rounded, color: AppColors.primary)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(doc!=null?'Document Selected ✓':'Upload Medical License / ID', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
        Text(doc!=null?doc.path.split('/').last:'PDF, JPG, or PNG (Max 5MB)', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)), overflow: TextOverflow.ellipsis),
      ])),
    ])));
}

Widget _toggleCard(String title, IconData icon, Color color, String subtitle, bool value, void Function(bool) onChanged) {
  return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(color: value?color.withOpacity(0.05):const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: value?color:const Color(0xFFE2E8F0), width: value?1.5:1)),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))), Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))])),
      Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    ]));
}

Widget _checkHospitalTile(Map<String, dynamic> h, bool selected, VoidCallback onTap) {
  return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: selected?AppColors.primary.withOpacity(0.08):Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: selected?AppColors.primary:const Color(0xFFE2E8F0), width: selected?1.5:1)),
    child: Row(children: [
      Icon(selected?Icons.check_box_rounded:Icons.check_box_outline_blank_rounded, color: selected?AppColors.primary:const Color(0xFF94A3B8), size: 20),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(h['institution_name']??'', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: selected?AppColors.primary:const Color(0xFF1E293B))),
        Text(h['institution_type']??'', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      ])),
    ])));
}

Widget _infoBox(String msg) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF86EFAC))),
  child: Row(children: [const Icon(Icons.info_outline, color: Color(0xFF16A34A), size: 18), const SizedBox(width: 10), Expanded(child: Text(msg, style: const TextStyle(fontSize: 12, color: Color(0xFF15803D))))]));
