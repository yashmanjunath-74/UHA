import 'package:flutter/material.dart';

class LabStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const LabStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
