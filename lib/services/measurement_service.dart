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
    // -------------------------------------------------------------------------
    // FAKE DATA FOR FRONTEND TESTING WITHOUT BACKEND
    // -------------------------------------------------------------------------
    await Future.delayed(const Duration(seconds: 1));

    return [
      Measurement(
        id: '1',
        citizenId: citizenId,
        citizenName: _getCitizenName(citizenId),
        citizenPhoneNumber: _getCitizenPhoneNumber(citizenId),
        pulse: 82,
        spo2: 98,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isCritical: false,
      ),
      Measurement(
        id: '2',
        citizenId: citizenId,
        citizenName: _getCitizenName(citizenId),
        citizenPhoneNumber: _getCitizenPhoneNumber(citizenId),
        pulse: 88,
        spo2: 97,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isCritical: false,
      ),
      Measurement(
        id: '3',
        citizenId: citizenId,
        citizenName: _getCitizenName(citizenId),
        citizenPhoneNumber: _getCitizenPhoneNumber(citizenId),
        pulse: 105,
        spo2: 94,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isCritical: false,
      ),
      Measurement(
        id: '4',
        citizenId: citizenId,
        citizenName: _getCitizenName(citizenId),
        citizenPhoneNumber: _getCitizenPhoneNumber(citizenId),
        pulse: 132,
        spo2: 88,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isCritical: true,
      ),
    ];

    // -------------------------------------------------------------------------
    // REAL BACKEND CODE - USE THIS WHEN NESTJS BACKEND IS READY
    // -------------------------------------------------------------------------
    /*
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
    */
  }

  /// Returns fake citizen names based on citizen id.
  String _getCitizenName(String citizenId) {
    switch (citizenId) {
      case '1':
        return 'Bent Hansen';
      case '2':
        return 'Karen Jensen';
      case '3':
        return 'Ole Pedersen';
      default:
        return 'Unknown citizen';
    }
  }

  /// Returns fake phone numbers based on citizen id.
  String _getCitizenPhoneNumber(String citizenId) {
    switch (citizenId) {
      case '1':
        return '+45 12 34 56 78';
      case '2':
        return '+45 87 65 43 21';
      case '3':
        return '+45 22 33 44 55';
      default:
        return '';
    }
  }
}