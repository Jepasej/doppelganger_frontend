import 'dart:convert';
import '../models/measurement.dart';
import 'api_client_service.dart';

/// Service responsible for measurement data.
/// Uses ApiClientService so authentication and token handling are centralized.
class MeasurementService {
  final ApiClientService apiClientService = ApiClientService();

  /// GETS MEASUREMENTS FOR ONE CITIZEN FROM THE BACKEND
  Future<List<Measurement>> getMeasurementsForCitizen(String citizenId) async {
    final response = await apiClientService.get(
      '/citizens/$citizenId/measurements',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load measurements');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Measurement.fromJson(item)).toList();
  }

  /// GETS ALL CRITICAL MEASUREMENTS FROM THE BACKEND
  Future<List<Measurement>> getCriticalMeasurements() async {
    final response = await apiClientService.get('/measurements/critical');

    if (response.statusCode != 200) {
      throw Exception('Failed to load critical measurements');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Measurement.fromJson(item)).toList();
  }
}