import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/measurement.dart';

/// Defines which measurement type should be shown in the chart.
enum MeasurementChartType {
  spo2,
  pulse,
}

/// Reusable chart widget for citizen measurements.
/// It can show either SpO2 or pulse depending on the selected tab.
class MeasurementChart extends StatelessWidget {
  final List<Measurement> measurements;
  final MeasurementChartType selectedType;

  const MeasurementChart({
    super.key,
    required this.measurements,
    required this.selectedType,
  });

  /// Returns the correct value based on the selected chart type.
  double getMeasurementValue(Measurement measurement) {
    if (selectedType == MeasurementChartType.spo2) {
      return measurement.spo2;
    }

    return measurement.pulse.toDouble();
  }

  /// Formats date and time for the bottom labels in the chart.
  String formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month $hour:$minute';
  }

  /// Returns the title shown above the chart.
  String get chartTitle {
    if (selectedType == MeasurementChartType.spo2) {
      return 'SpO2 measurements';
    }

    return 'Pulse measurements';
  }

  /// Returns the unit shown with the selected measurement.
  String get unit {
    if (selectedType == MeasurementChartType.spo2) {
      return '%';
    }

    return 'bpm';
  }

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return const Center(
        child: Text('No measurements available'),
      );
    }

    /// Sort measurements by time so the graph is shown chronologically.
    final sortedMeasurements = [...measurements]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final spots = <FlSpot>[];

    for (int i = 0; i < sortedMeasurements.length; i++) {
      final measurement = sortedMeasurements[i];

      /// x = index in the list.
      /// y = selected measurement value, for example SpO2 or pulse.
      spots.add(
        FlSpot(
          i.toDouble(),
          getMeasurementValue(measurement),
        ),
      );
    }

    final latestMeasurement = sortedMeasurements.last;
    final latestValue = getMeasurementValue(latestMeasurement);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chartTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Latest value: $latestValue $unit',
          style: const TextStyle(fontSize: 16),
        ),

        Text(
          'Latest time: ${formatDateTime(latestMeasurement.createdAt)}',
          style: const TextStyle(fontSize: 14),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: LineChart(
            LineChartData(
              minY: selectedType == MeasurementChartType.spo2 ? 80 : null,
              maxY: selectedType == MeasurementChartType.spo2 ? 100 : null,

              /// Makes the graph easier to read.
              gridData: const FlGridData(show: true),

              /// Shows labels on the left and bottom side.
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(unit),
                  sideTitles: const SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Date and time'),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 || index >= sortedMeasurements.length) {
                        return const SizedBox.shrink();
                      }

                      final measurement = sortedMeasurements[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          formatDateTime(measurement.createdAt),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// Shows a small tooltip when the user taps a point.
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final measurement =
                          sortedMeasurements[spot.x.toInt()];

                      final value = getMeasurementValue(measurement);

                      return LineTooltipItem(
                        '$value $unit\n${formatDateTime(measurement.createdAt)}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),

              /// Draws the actual graph line.
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}