import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'token_storage_service.dart';

/// Service responsible for authentication.
/// Handles login, JWT token storage and access token refresh.
class AuthService {
  final TokenStorageService tokenStorageService = TokenStorageService();

  /// Sends credentials to the backend and stores accessToken and refreshToken.
  Future<String> login(String username, String password) async {
    final url = Uri.parse('${ApiService.baseUrl}/authentication/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Login failed');
    }

    final data = jsonDecode(response.body);

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    await tokenStorageService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return accessToken;
  }

  /// Uses the refresh token to request a new access token from the backend.
  Future<String> refreshAccessToken() async {
    final refreshToken = await tokenStorageService.getRefreshToken();

    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    final url = Uri.parse('${ApiService.baseUrl}/authentication/refresh');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not refresh access token');
    }

    final data = jsonDecode(response.body);
    final newAccessToken = data['accessToken'];

    await tokenStorageService.saveAccessToken(newAccessToken);

    return newAccessToken;
  }

  /// Signs off the user by deleting stored tokens.
  Future<void> signOff() async {
    await tokenStorageService.clearTokens();
  }
}