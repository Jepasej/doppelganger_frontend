import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/citizen.dart';
import 'api_service.dart';

/// Service class responsible for citizens.
/// This class fetches citizens from the backend or returns fake data for testing.
class CitizenService {
  /// Gets all citizens.
  /// Right now this method uses fake data so the frontend can be tested without backend.
  Future<List<Citizen>> getCitizens(String token) async {
    // -------------------------------------------------------------------------
    // FAKE DATA FOR FRONTEND TESTING WITHOUT BACKEND
    // -------------------------------------------------------------------------
    await Future.delayed(const Duration(seconds: 1));

    return const [
      Citizen(
        id: '1',
        fullName: 'Bent Hansen',
        address: 'Parkvej 12',
        phoneNumber: '+45 12 34 56 78',
      ),
      Citizen(
        id: '2',
        fullName: 'Karen Jensen',
        address: 'Birkevej 8',
        phoneNumber: '+45 87 65 43 21',
      ),
      Citizen(
        id: '3',
        fullName: 'Ole Pedersen',
        address: 'Søndergade 4',
        phoneNumber: '+45 22 33 44 55',
      ),
    ];

    // -------------------------------------------------------------------------
    // REAL BACKEND CODE - USE THIS WHEN NESTJS BACKEND IS READY
    // -------------------------------------------------------------------------
    /*
    final url = Uri.parse('${ApiService.baseUrl}/citizens');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load citizens');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Citizen.fromJson(item)).toList();
    */
  }
}