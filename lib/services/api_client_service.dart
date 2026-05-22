import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'auth_service.dart';
import 'token_storage_service.dart';

/// Central HTTP service for the application.
/// Automatically attaches JWT access tokens to requests.
/// If the backend returns 401 Unauthorized, the service automatically
/// requests a new access token using the refresh token and retries the request.
class ApiClientService {
  final TokenStorageService tokenStorageService = TokenStorageService();
  final AuthService authService = AuthService();

  /// Sends an authenticated GET request to the backend.
  Future<http.Response> get(String endpoint) async {
    final accessToken = await tokenStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    /// If access token has expired, refresh it and retry the request.
    if (response.statusCode == 401) {
      final newAccessToken = await authService.refreshAccessToken();

      return http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: {
          'Authorization': 'Bearer $newAccessToken',
        },
      );
    }

    return response;
  }

  /// Sends an authenticated POST request to the backend.
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final accessToken = await tokenStorageService.getAccessToken();

    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    /// If access token has expired, refresh it and retry the request.
    if (response.statusCode == 401) {
      final newAccessToken = await authService.refreshAccessToken();

      return http.post(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $newAccessToken',
        },
        body: jsonEncode(body),
      );
    }

    return response;
  }
}