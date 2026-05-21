import 'package:flutter/material.dart';
import '../models/measurement.dart';

/// Reusable widget for showing one measurement.
/// It can be used on both the citizen detail screen and other measurement views.
class MeasurementCard extends StatelessWidget {
  final Measurement measurement;

  const MeasurementCard({
    super.key,
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: measurement.isCritical ? Colors.red.shade50 : null,
      child: ListTile(
        leading: Icon(
          measurement.isCritical ? Icons.warning : Icons.favorite,
          color: measurement.isCritical ? Colors.red : Colors.green,
        ),
        title: Text(
          'Pulse: ${measurement.pulse} | SpO2: ${measurement.spo2}%',
        ),
        subtitle: Text(
          'Measured at: ${measurement.createdAt}',
        ),
      ),
    );
  }
}