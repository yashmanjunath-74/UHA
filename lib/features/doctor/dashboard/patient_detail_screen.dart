import 'package:flutter/material.dart';


class PatientDetailScreen extends StatelessWidget {
  final String patientName, gender, condition;
  final int age;
  const PatientDetailScreen({super.key, required this.patientName, required this.gender, required this.age, required this.condition});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        body: SafeArea(
          child: Column(
            children: [
              // ── AppBar area ─────────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                child: Column(children: [
                  Row(children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)), onPressed: () => Navigator.pop(context)),
                    const Expanded(child: Center(child: Text('Patient 360°', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))))),
                    const Icon(Icons.more_horiz, color: Color(0xFF475569)),
                  ]),
                  const SizedBox(height: 16),
                  // Patient Summary Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(children: [
                      Stack(children: [
                        CircleAvatar(radius: 36, backgroundColor: const Color(0xFFE8F5F1), child: Text(patientName[0], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF10B981)))),
                        Positioned(bottom: 2, right: 2, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 12))),
                      ]),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(patientName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const SizedBox(height: 6),
                        Row(children: [
                          _chip(Icons.cake_outlined, '$age Yrs', const Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          _chip(gender == 'Female' ? Icons.female : Icons.male, gender, const Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          _chip(Icons.water_drop_outlined, 'A+', const Color(0xFF10B981)),
                        ]),
                      ])),
                    ]),
                  ),
                  // AI Insight
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF86EFAC))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.auto_awesome, color: Color(0xFF10B981), size: 14)),
                        const SizedBox(width: 6),
                        const Text('AI HEALTH INSIGHT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981), letterSpacing: 0.5)),
                      ]),
                      const SizedBox(height: 6),
                      Text('Summary: Patient has history of $condition. Vitals are currently stable. Last visit 2 months ago.', style: const TextStyle(fontSize: 12, color: Color(0xFF166534))),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  TabBar(
                    labelColor: const Color(0xFF10B981),
                    unselectedLabelColor: const Color(0xFF94A3B8),
                    indicatorColor: const Color(0xFF10B981),
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [Tab(text: 'Timeline'), Tab(text: 'Lab Reports'), Tab(text: 'Vitals'), Tab(text: 'Prescriptions')],
                  ),
                ]),
              ),

              // ── Tab Content ──────────────────────────────────────
              Expanded(
                child: TabBarView(children: [
                  _TimelineTab(condition: condition),
                  _LabReportsTab(),
                  _VitalsTab(),
                  _PrescriptionsTab(),
                ]),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF10B981),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  static Widget _chip(IconData icon, String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 3),
      Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    ]);
  }
}

// ─── Timeline Tab ─────────────────────────────────────────
class _TimelineTab extends StatelessWidget {
  final String condition;
  const _TimelineTab({required this.condition});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'General Consultation', 'date': 'Oct 12, 2023', 'subtitle': 'Dr. Smith • Family Medicine', 'detail': 'Reported high fever and fatigue. Diagnosed with seasonal flu. Prescribed Tamiflu and rest.', 'tag': 'Flu Symptoms', 'tagColor': const Color(0xFFF59E0B), 'icon': Icons.medical_services_outlined},
      {'title': 'Lab Results: Blood Panel', 'date': 'Aug 05, 2023', 'subtitle': 'Central Lab • Ref #88392', 'detail': '✓ All markers within normal range', 'tag': 'View Full Report →', 'tagColor': const Color(0xFF10B981), 'icon': Icons.science_outlined},
      {'title': 'Vaccination', 'date': 'Feb 20, 2021', 'subtitle': 'Community Clinic', 'detail': 'COVID-19 Booster Shot (Pfizer-BioNTech)', 'tag': '', 'tagColor': Colors.transparent, 'icon': Icons.vaccines_outlined},
      {'title': 'Initial Diagnosis: $condition', 'date': 'Jan 10, 2019', 'subtitle': 'City Hospital', 'detail': 'Patient presented with relevant symptoms. Initial diagnosis confirmed.', 'tag': condition, 'tagColor': const Color(0xFF6366F1), 'icon': Icons.description_outlined},
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline line & icon
                Column(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFE8F5F1), shape: BoxShape.circle), child: Icon(item['icon'] as IconData, size: 18, color: const Color(0xFF10B981))),
                  if (i < items.length - 1) Expanded(child: Container(width: 2, color: const Color(0xFFE2E8F0))),
                ]),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)))),
                          Text(item['date'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ]),
                        const SizedBox(height: 3),
                        Text(item['subtitle'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        Text(item['detail'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
                        if ((item['tag'] as String).isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: (item['tagColor'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(item['tag'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: item['tagColor'] as Color)),
                          ),
                        ],
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Lab Reports Tab ──────────────────────────────────────
class _LabReportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labs = [
      {'name': 'Blood Panel (CBC)', 'lab': 'Central Diagnostics', 'date': 'Aug 05, 2023', 'status': 'Normal', 'statusColor': const Color(0xFF10B981)},
      {'name': 'HbA1c — Diabetes Screen', 'lab': 'Apollo Labs', 'date': 'Jun 20, 2023', 'status': 'Borderline', 'statusColor': const Color(0xFFF59E0B)},
      {'name': 'Lipid Profile', 'lab': 'Central Diagnostics', 'date': 'Mar 12, 2023', 'status': 'Normal', 'statusColor': const Color(0xFF10B981)},
      {'name': 'Chest X-Ray', 'lab': 'City Radiology', 'date': 'Jan 05, 2023', 'status': 'Clear', 'statusColor': const Color(0xFF10B981)},
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: labs.length,
      itemBuilder: (_, i) {
        final l = labs[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE8F5F1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.science_outlined, color: Color(0xFF10B981), size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
              Text('${l['lab']}  •  ${l['date']}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: (l['statusColor'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(l['status'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: l['statusColor'] as Color))),
          ]),
        );
      },
    );
  }
}

// ─── Vitals Tab ───────────────────────────────────────────
class _VitalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(children: [
        Row(children: [
          Expanded(child: _vitalCard('Blood Pressure', '120/80', 'mmHg', Icons.monitor_heart_outlined, const Color(0xFF2C6BFF), 'Normal')),
          const SizedBox(width: 12),
          Expanded(child: _vitalCard('Heart Rate', '78', 'bpm', Icons.favorite_outlined, const Color(0xFFEF4444), 'Normal')),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _vitalCard('Temperature', '98.6', '°F', Icons.thermostat_outlined, const Color(0xFFF59E0B), 'Normal')),
          const SizedBox(width: 12),
          Expanded(child: _vitalCard('SpO2', '98', '%', Icons.air_outlined, const Color(0xFF10B981), 'Excellent')),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _vitalCard('Weight', '72', 'kg', Icons.monitor_weight_outlined, const Color(0xFF6366F1), 'Healthy')),
          const SizedBox(width: 12),
          Expanded(child: _vitalCard('BMI', '23.4', 'kg/m²', Icons.person_outlined, const Color(0xFF10B981), 'Normal')),
        ]),
      ]),
    );
  }

  Widget _vitalCard(String label, String value, String unit, IconData icon, Color color, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 4),
          Text(unit, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981)))),
      ]),
    );
  }
}

// ─── Prescriptions Tab ────────────────────────────────────
class _PrescriptionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rx = [
      {'name': 'Amoxicillin 500mg', 'type': 'Capsule', 'freq': '1-0-1', 'duration': '5 Days', 'date': 'Oct 12, 2023', 'doctor': 'Dr. Smith'},
      {'name': 'Paracetamol 650mg', 'type': 'Tablet', 'freq': '1-1-1', 'duration': '3 Days', 'date': 'Oct 12, 2023', 'doctor': 'Dr. Smith'},
      {'name': 'Cetirizine 10mg', 'type': 'Tablet', 'freq': '0-0-1', 'duration': '7 Days', 'date': 'Aug 05, 2023', 'doctor': 'Dr. Mehta'},
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: rx.length,
      itemBuilder: (_, i) {
        final r = rx[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(r['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
              Text(r['date'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ]),
            const SizedBox(height: 4),
            Text('${r['type']}  •  ${r['doctor']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            Row(children: [
              _rxBadge('${r['freq']}', const Color(0xFF2C6BFF)),
              const SizedBox(width: 8),
              _rxBadge('${r['duration']}', const Color(0xFF6366F1)),
            ]),
          ]),
        );
      },
    );
  }

  Widget _rxBadge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
  );
}
