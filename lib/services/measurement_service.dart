import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/measurement.dart';
import 'api_service.dart';

/// Service class responsible for measurements.

/// This class handles HTTP requests related to vital measurements.
class MeasurementService {

  /// Gets measurements for one citizen.
  /// Right now this method uses fake data so the frontend can be tested without backend.
  Future<List<Measurement>> getMeasurementsForCitizen(
    String citizenId,
    String token,
  ) async {
    final url = Uri.parse(
      '${ApiService.baseUrl}/citizens/$citizenId/measurements',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load measurements');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Measurement.fromJson(item)).toList();
  }

  Future<List<Measurement>> getCriticalMeasurements(String token) async {
    final url = Uri.parse('${ApiService.baseUrl}/measurements/critical');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load critical measurements');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Measurement.fromJson(item)).toList();
  }
}