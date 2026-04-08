import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class DoctorRosterManagement extends StatefulWidget {
  const DoctorRosterManagement({super.key});

  @override
  State<DoctorRosterManagement> createState() => _DoctorRosterManagementState();
}

class _DoctorRosterManagementState extends State<DoctorRosterManagement> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    // We remove Scaffold to avoid nested task bars
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: AppColors.neutral500),
                      onPressed: () => _changeMonth(-1),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_currentMonth),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neutral900),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: AppColors.neutral500),
                      onPressed: () => _changeMonth(1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date Strip (Dynamic)
                _buildDynamicDateStrip(),
                const SizedBox(height: 24),

                // Legend
                Row(
                  children: [
                    _buildLegendDot(AppColors.primary, 'On Duty'),
                    const SizedBox(width: 16),
                    _buildLegendDot(const Color(0xFFFF9F43), 'In Surgery'),
                    const SizedBox(width: 16),
                    _buildLegendDot(AppColors.neutral400, 'On Leave'),
                  ],
                ),
                const SizedBox(height: 24),

                // Shifts Section
                _buildShiftSection(
                  'Morning Shift',
                  '08:00 - 16:00',
                  Icons.wb_sunny_rounded,
                  const Color(0xFFFFF9C4),
                  Colors.orange,
                  [
                    _buildDoctorCard('Dr. Alan Grant', 'Cardiology', 'ON DUTY', Colors.white, const Color(0xFFCCFBF1), AppColors.primary),
                    const SizedBox(height: 16),
                    _buildDoctorCard('Dr. Ellie Sattler', 'Pediatrics', 'SURGERY', Colors.white, const Color(0xFFFFEAD0), const Color(0xFFFF9F43)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildShiftSection(
                  'Evening Shift',
                  '16:00 - 00:00',
                  Icons.nights_stay_rounded,
                  const Color(0xFFE8EAF6),
                  const Color(0xFF3F51B5),
                  [
                    _buildDoctorCard('Dr. Ian Malcolm', 'Neurology', 'ON DUTY', Colors.white, const Color(0xFFCCFBF1), AppColors.primary),
                    const SizedBox(height: 16),
                    _buildAssignDoctorPlaceholder(),
                  ],
                ),
                const SizedBox(height: 120), // Padding for the dashboard bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicDateStrip() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final List<DateTime> dates = List.generate(
      daysInMonth,
      (index) => DateTime(_currentMonth.year, _currentMonth.month, index + 1),
    );

    return SizedBox(
      height: 85,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate.day == date.day && _selectedDate.month == date.month && _selectedDate.year == date.year;
          return GestureDetector(
            onTap: () => _onDateSelected(date),
            child: _buildDateItem(DateFormat('E').format(date), date.day.toString(), isActive: isSelected),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Roster Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
              SizedBox(height: 4),
              Text('Manage shifts & staff', style: TextStyle(fontSize: 14, color: AppColors.neutral500)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.filter_list, color: AppColors.neutral900),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, {bool isActive = false}) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isActive ? Colors.white.withOpacity(0.8) : AppColors.neutral500)),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppColors.neutral900)),
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.neutral600)),
    ]);
  }

  Widget _buildShiftSection(String title, String time, IconData icon, Color iconBgColor, Color iconColor, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
            Text(time, style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
          ]),
        ]),
        const Icon(Icons.add, color: AppColors.primary),
      ]),
      const SizedBox(height: 16),
      ...children,
    ]);
  }

  Widget _buildDoctorCard(String name, String specialty, String status, Color bgColor, Color statusBgColor, Color statusTextColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))]),
      child: Row(children: [
        CircleAvatar(radius: 24, backgroundColor: AppColors.neutral100, child: const Icon(Icons.person, color: AppColors.neutral400)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          Text(specialty, style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)), child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusTextColor))),
      ]),
    );
  }

  Widget _buildAssignDoctorPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.neutral200, width: 1.5)),
      child: Column(children: [
        const Text('Needs one more staff', style: TextStyle(fontSize: 14, color: AppColors.neutral500)),
        const SizedBox(height: 8),
        Text('Assign Doctor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ]),
    );
  }
}
