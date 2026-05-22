import 'package:flutter/material.dart';
import '../models/citizen.dart';
import '../models/measurement.dart';
import 'citizen_detail_screen.dart';

/// Screen shown when a critical measurement is received.

/// This screen can be opened globally by the WebSocket service.
class CriticalMeasurementScreen extends StatelessWidget {
  final Measurement measurement;
  final String token;

  const CriticalMeasurementScreen({
    super.key,
    required this.measurement,
    required this.token,
  });

  /// Opens the citizen detail screen for the citizen
  /// related to the critical measurement.
  void openCitizenDetailScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CitizenDetailScreen(
          token: token,
          citizen: Citizen(
            id: measurement.citizenId,
            fullName: measurement.citizenName,
            address: 'Unknown address',
            phoneNumber: measurement.citizenPhoneNumber,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Critical measurement'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 90,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Critical measurement received',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    measurement.citizenName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Phone: ${measurement.citizenPhoneNumber}'),
                  Text('Pulse: ${measurement.pulse}'),
                  Text('SpO2: ${measurement.spo2}%'),
                  Text('Time: ${measurement.createdAt}'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      openCitizenDetailScreen(context);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open citizen details'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}