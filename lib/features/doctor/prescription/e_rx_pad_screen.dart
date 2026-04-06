import 'package:flutter/material.dart';


/// Full-featured E-Rx Pad matching the design screenshot.
/// Stateful so medications can be added/removed interactively.
class ERxPadScreen extends StatefulWidget {
  const ERxPadScreen({super.key});
  @override State<ERxPadScreen> createState() => _ERxPadScreenState();
}

class _ERxPadScreenState extends State<ERxPadScreen> {
  final _diagnosisCtrl = TextEditingController();
  final _drugCtrl = TextEditingController();

  final List<Map<String, dynamic>> _medications = [
    {'name': 'Amoxicillin', 'dosage': '500mg', 'form': 'Capsule', 'morning': 1, 'afternoon': 0, 'night': 1, 'duration': '5 Days', 'alert': 'Interaction alert: Mild reaction with history.'},
  ];

  final List<String> _durationOptions = ['3 Days', '5 Days', '7 Days', '10 Days', '14 Days', '1 Month'];

  @override void dispose() { _diagnosisCtrl.dispose(); _drugCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        // ── Header ───────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(children: [
            const Expanded(child: Text('E-Rx Pad', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
            CircleAvatar(radius: 20, backgroundColor: const Color(0xFFE8F5F1), child: const Icon(Icons.person, color: Color(0xFF10B981), size: 22)),
          ]),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Patient info
              Text('New Prescription for John Doe', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: [
                _tagChip('MALE', const Color(0xFF2C6BFF)),
                const Text('34 Years Old', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                const Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                const Text('Allergies: ', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                const Text('Penicillin', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
              ]),
              const SizedBox(height: 20),

              // Diagnosis & Notes
              _sectionLabel('DIAGNOSIS & NOTES', rightWidget: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history, size: 14, color: Color(0xFF10B981)),
                label: const Text('History', style: TextStyle(color: Color(0xFF10B981), fontSize: 12)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              )),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(children: [
                  Expanded(child: TextField(controller: _diagnosisCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Enter diagnosis, symptoms, or clinical observations…', hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.all(14)))),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.mic_rounded, color: Color(0xFF10B981), size: 22)),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // Medications
              _sectionLabel('MEDICATIONS'),
              const SizedBox(height: 12),
              
              ..._medications.asMap().entries.map((e) => _buildMedCard(e.key, e.value)),

              const SizedBox(height: 12),
              // Add drug field
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(padding: EdgeInsets.fromLTRB(14, 10, 14, 4), child: Text('DRUG NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                  TextField(
                    controller: _drugCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(hintText: 'Type drug name…', hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.fromLTRB(14, 0, 14, 10)),
                  ),
                  if (_drugCtrl.text.isNotEmpty) Container(
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Padding(padding: EdgeInsets.fromLTRB(14, 10, 14, 4), child: Text('SUGGESTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                      ...[
                        'Aspirin 75mg — Blood Thinner • Tablet',
                        'Aspirin 100mg — Gastro-resistant • Tablet',
                        'Aspirex 150mg — Dispersible • Tablet',
                      ].map((s) => InkWell(
                        onTap: () { _drugCtrl.clear(); setState((){}); },
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), child: Text(s, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)))),
                      )),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              // AI Interaction check
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFDDD6FE))),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 18),
                    SizedBox(width: 8),
                    Text('Check Interactions with AI', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF7C3AED))),
                  ]),
                ),
              ),
              const SizedBox(height: 12),

              // Sign & Send
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Sign & Send Prescription', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildMedCard(int index, Map<String, dynamic> med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF10B981), width: 1.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(med['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            Text('${med['dosage']}  •  ${med['form']}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          ])),
          IconButton(icon: const Icon(Icons.close, size: 18, color: Color(0xFF94A3B8)), onPressed: () => setState(() => _medications.removeAt(index))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const Text('FREQUENCY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
          const Spacer(),
          const Text('DURATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          _freqBox(med['morning'] as int, 'Morning', () => setState(() => med['morning'] = (med['morning'] as int) == 0 ? 1 : 0)),
          const SizedBox(width: 6),
          _freqBox(med['afternoon'] as int, 'Afternoon', () => setState(() => med['afternoon'] = (med['afternoon'] as int) == 0 ? 1 : 0)),
          const SizedBox(width: 6),
          _freqBox(med['night'] as int, 'Night', () => setState(() => med['night'] = (med['night'] as int) == 0 ? 1 : 0)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: med['duration'] as String,
                onChanged: (v) => setState(() => med['duration'] = v),
                items: _durationOptions.map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13)))).toList(),
                icon: const Icon(Icons.expand_more, size: 16),
              ),
            ),
          ),
        ]),
        if (med['alert'] != null && (med['alert'] as String).isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 14),
            const SizedBox(width: 6),
            Expanded(child: Text(med['alert'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFFF59E0B)))),
          ]),
        ],
      ]),
    );
  }

  Widget _freqBox(int value, String label, VoidCallback onTap) {
    final active = value == 1;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40, height: 40,
        decoration: BoxDecoration(color: active ? const Color(0xFF10B981) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text('$value', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: active ? Colors.white : const Color(0xFF64748B))),
      ),
    );
  }

  Widget _sectionLabel(String label, {Widget? rightWidget}) => Row(children: [
    Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
    const Spacer(),
    if (rightWidget != null) rightWidget,
  ]);

  Widget _tagChip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
  );
}
