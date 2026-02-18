import 'package:flutter/material.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';

class DesignViewerScreen extends StatelessWidget {
  const DesignViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Viewer (Debug)'),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Core & Auth', [
            _RouteItem('Splash Screen', '/'),
            _RouteItem('Role Selection', '/role_selection'),
            _RouteItem('Login', '/login'),
          ]),
          _buildSection(context, 'Patient Features', [
            _RouteItem('Home Hub', '/patient/home'),
            _RouteItem('Digital File', '/patient/digital_file'),
            _RouteItem('Health Timeline', '/patient/timeline'),
            _RouteItem('Symptom Triage', '/patient/triage'),
          ]),
          _buildSection(context, 'Doctor Features', [
            _RouteItem('Dashboard', '/doctor/dashboard'),
            _RouteItem('Roster', '/doctor/roster'),
            _RouteItem('Prescription Pad', '/doctor/prescription'),
          ]),
          _buildSection(context, 'Pharmacy Features', [
            _RouteItem('Order Queue', '/pharmacy/orders'),
            _RouteItem('Fulfillment', '/pharmacy/fulfillment'),
            _RouteItem('Inventory', '/pharmacy/inventory'),
            _RouteItem('Earnings', '/pharmacy/earnings'),
          ]),
          _buildSection(context, 'Hospital Features', [
            _RouteItem('Admin Overview', '/hospital/dashboard'),
          ]),
          _buildSection(context, 'Registration Flows', [
            _RouteItem('Basic Info', '/registration/basic'),
            _RouteItem('Doctor Profile', '/registration/doctor_profile'),
            _RouteItem('Hospital Profile', '/registration/hospital_profile'),
            _RouteItem('Lab Profile', '/registration/lab_profile'),
            _RouteItem('Pharmacy Upload', '/registration/pharmacy_upload'),
          ]),
          _buildSection(context, 'Premium Features', [
            _RouteItem('Premium Dashboard', '/dashboard'),
          ]),
          _buildSection(context, 'Common', [
            _RouteItem('Search Results', '/search/doctors'),
            _RouteItem('Payment Confirm', '/booking/payment'),
            _RouteItem('Success Screen', '/success'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<_RouteItem> items,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        children: items
            .map(
              (item) => ListTile(
                title: Text(item.name),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.pushNamed(context, item.route),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RouteItem {
  final String name;
  final String route;

  const _RouteItem(this.name, this.route);
}
