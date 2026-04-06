import 'package:flutter/material.dart';

import 'patient_detail_screen.dart';

class DoctorPatientsTab extends StatefulWidget {
  const DoctorPatientsTab({super.key});
  @override State<DoctorPatientsTab> createState() => _DoctorPatientsTabState();
}

class _DoctorPatientsTabState extends State<DoctorPatientsTab> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All';
  final _filters = ['All', 'Today', 'Critical', 'Chronic', 'Pediatric'];

  final _patients = [
    {'name': 'John Doe', 'age': 45, 'gender': 'Male', 'condition': 'High Fever', 'lastVisit': 'Today', 'status': 'Critical', 'initials': 'JD', 'blood': 'O+'},
    {'name': 'Jane Roe', 'age': 32, 'gender': 'Female', 'condition': 'Annual Checkup', 'lastVisit': 'Today', 'status': 'Stable', 'initials': 'JR', 'blood': 'A+'},
    {'name': 'Robert Brown', 'age': 60, 'gender': 'Male', 'condition': 'Back Pain Review', 'lastVisit': 'Today', 'status': 'Chronic', 'initials': 'RB', 'blood': 'B+'},
    {'name': 'Emma Lewis', 'age': 8, 'gender': 'Female', 'condition': 'Vaccination', 'lastVisit': 'Yesterday', 'status': 'Stable', 'initials': 'EL', 'blood': 'AB+'},
    {'name': 'Arjun Sharma', 'age': 52, 'gender': 'Male', 'condition': 'Cardiology Follow-up', 'lastVisit': '3 days ago', 'status': 'Chronic', 'initials': 'AS', 'blood': 'O-'},
    {'name': 'Priya Nair', 'age': 27, 'gender': 'Female', 'condition': 'Migraine', 'lastVisit': '1 week ago', 'status': 'Stable', 'initials': 'PN', 'blood': 'A-'},
    {'name': 'Vikram Rao', 'age': 70, 'gender': 'Male', 'condition': 'Diabetes Management', 'lastVisit': '2 weeks ago', 'status': 'Chronic', 'initials': 'VR', 'blood': 'B-'},
  ];

  @override void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Color _statusColor(String status) {
    switch (status) {
      case 'Critical': return const Color(0xFFEF4444);
      case 'Chronic': return const Color(0xFFF59E0B);
      default: return const Color(0xFF10B981);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _filter == 'All' ? _patients : _patients.where((p) {
      if (_filter == 'Today') return p['lastVisit'] == 'Today';
      if (_filter == 'Pediatric') return (p['age'] as int) < 18;
      return p['status'] == _filter;
    }).toList();
    if (_searchCtrl.text.isNotEmpty) {
      list = list.where((p) => (p['name'] as String).toLowerCase().contains(_searchCtrl.text.toLowerCase())).toList();
    }
    return list.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(children: [
            Row(children: [
              const Expanded(child: Text('Patients', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF475569))),
            ]),
            const SizedBox(height: 14),
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search patients…',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                filled: true, fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final active = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : const Color(0xFF64748B))),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: _filtered.length,
            itemBuilder: (context, i) {
              final p = _filtered[i];
              final sColor = _statusColor(p['status'] as String);
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailScreen(patientName: p['name'] as String, gender: p['gender'] as String, age: p['age'] as int, condition: p['condition'] as String))),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
                  child: Row(children: [
                    CircleAvatar(radius: 24, backgroundColor: const Color(0xFFE8F5F1), child: Text(p['initials'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 15))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B))),
                      const SizedBox(height: 3),
                      Text('${p['gender']}, ${p['age']} yrs  •  ${p['condition']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 3),
                      Text('Last: ${p['lastVisit']}  •  Blood: ${p['blood']}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: sColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(p['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: sColor))),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
