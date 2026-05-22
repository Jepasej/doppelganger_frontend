import 'package:flutter/material.dart';
import '../models/citizen.dart';
import '../models/measurement.dart';
import '../services/auth_service.dart';
import '../services/measurement_service.dart';
import '../services/sse_service.dart';
import '../widgets/measurement_card.dart';
import '../widgets/measurement_chart.dart';
import 'login_screen.dart';

/// Detail screen for one citizen.
/// Displays citizen information, latest measurements and charts.
class CitizenDetailScreen extends StatefulWidget {
  final Citizen citizen;

  const CitizenDetailScreen({
    super.key,
    required this.citizen,
  });

  @override
  State<CitizenDetailScreen> createState() => _CitizenDetailScreenState();
}

/// State class for the citizen detail screen.
/// Stores measurements, loading state and selected chart type.
class _CitizenDetailScreenState extends State<CitizenDetailScreen> {
  final MeasurementService measurementService = MeasurementService();
  final AuthService authService = AuthService();

  List<Measurement> measurements = [];
  bool isLoading = true;
  String? errorMessage;

  /// Controls which measurement type is shown in the chart.
  /// 0 = SpO2, 1 = Pulse.
  int selectedTabIndex = 0;

  /// Loads measurements when the screen opens.
  @override
  void initState() {
    super.initState();
    loadMeasurements();
  }

  /// Gets measurement data from the backend and updates the UI.
  Future<void> loadMeasurements() async {
    try {
      final result = await measurementService.getMeasurementsForCitizen(
        widget.citizen.id,
      );

      setState(() {
        measurements = result;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Could not load measurements';
        isLoading = false;
      });
    }
  }

  /// Signs the off the health care worker by clearing tokens, disconnects SSE and returns to login screen.
  Future<void> signOff() async {
    await authService.signOff();
    await SseService.instance.disconnect();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final latestMeasurements = measurements.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.citizen.fullName),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT SIDE - LATEST MEASUREMENTS
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Latest measurements',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                for (final measurement in latestMeasurements)
                                  MeasurementCard(
                                    measurement: measurement,
                                  ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: signOff,
                                    icon: const Icon(Icons.logout),
                                    label: const Text('Sign off'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      /// RIGHT SIDE - CITIZEN INFO + CHART
                      Expanded(
                        flex: 2,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Citizen information',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(width: 8),
                                    Text(widget.citizen.fullName),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.home),
                                    const SizedBox(width: 8),
                                    Text(widget.citizen.address),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.phone),
                                    const SizedBox(width: 8),
                                    Text(widget.citizen.phoneNumber),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                const Text(
                                  'Measurement chart',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SegmentedButton<int>(
                                  segments: const [
                                    ButtonSegment<int>(
                                      value: 0,
                                      label: Text('SpO2'),
                                      icon: Icon(Icons.air),
                                    ),
                                    ButtonSegment<int>(
                                      value: 1,
                                      label: Text('Pulse'),
                                      icon: Icon(Icons.favorite),
                                    ),
                                  ],
                                  selected: {selectedTabIndex},
                                  onSelectionChanged: (newSelection) {
                                    setState(() {
                                      selectedTabIndex = newSelection.first;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: MeasurementChart(
                                    measurements: measurements,
                                    selectedType: selectedTabIndex == 0
                                        ? MeasurementChartType.spo2
                                        : MeasurementChartType.pulse,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}