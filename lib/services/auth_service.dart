import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// Service class responsible for login.

/// The service layer keeps HTTP logic away from the UI.
class AuthService {
  /// Logs in the user.
  /// Right now this method uses fake data so the frontend can be tested without backend.
  Future<String> login(String username, String password) async {
    // -------------------------------------------------------------------------
    // FAKE DATA FOR FRONTEND TESTING WITHOUT BACKEND
    // -------------------------------------------------------------------------
    await Future.delayed(const Duration(seconds: 1));

    return 'fake-jwt-token';

    // -------------------------------------------------------------------------
    // REAL BACKEND CODE - USE THIS WHEN NESTJS BACKEND IS READY
    // -------------------------------------------------------------------------
    /*
    final url = Uri.parse('${ApiService.baseUrl}/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Login failed');
    }

    final data = jsonDecode(response.body);

    return data['accessToken'];
    */
  }
}