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
  }
}