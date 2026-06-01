import 'dart:convert';
import '../models/citizen.dart';
import 'api_client_service.dart';

/// Service responsible for citizen data.
/// Uses ApiClientService so authentication and token handling are centralized.
class CitizenService {
  final ApiClientService apiClientService = ApiClientService();

  /// Gets all citizens from the backend.
  Future<List<Citizen>> getCitizens() async {
    final response = await apiClientService.get('/citizens');

    if (response.statusCode != 200) {
      throw Exception('Failed to load citizens');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Citizen.fromJson(item)).toList();
  }
}

