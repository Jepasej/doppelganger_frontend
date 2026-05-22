import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/measurement.dart';
import '../navigation/app_navigator.dart';
import '../screens/critical_measurement_screen.dart';
import 'api_service.dart';
import 'token_storage_service.dart';

/// Service responsible for Server-Sent Events communication.
/// SSE is used for one-way realtime communication from backend to Flutter.
/// The backend pushes critical measurements to connected Flutter clients.
class SseService {
  static final SseService instance = SseService._internal();

  SseService._internal();

  final TokenStorageService tokenStorageService = TokenStorageService();

  http.Client? _client;
  StreamSubscription<String>? _subscription;

  /// Connects to the backend SSE stream.
  /// The backend sends critical measurements through this stream.
  Future<void> connect() async {
    final accessToken = await tokenStorageService.getAccessToken();

    if (accessToken == null) {
      debugPrint('SSE could not connect because no access token was found.');
      return;
    }

    _client = http.Client();

    final request = http.Request(
      'GET',
      Uri.parse('${ApiService.baseUrl}/measurements/critical'), 
    );

    request.headers.addAll({
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Authorization': 'Bearer $accessToken',
    });

    final response = await _client!.send(request);

    if (response.statusCode != 200) {
      debugPrint('SSE connection failed: ${response.statusCode}');
      return;
    }

    _subscription = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
      _handleSseLine,
      onError: (error) {
        debugPrint('SSE error: $error');
      },
      onDone: () {
        debugPrint('SSE connection closed');
      },
    );
  }

  /// Handles each line received from the SSE stream.
  /// SSE sends data lines that begin with "data:".
  void _handleSseLine(String line) {
    if (!line.startsWith('data:')) {
      return;
    }

    final jsonText = line.replaceFirst('data:', '').trim();

    if (jsonText.isEmpty) {
      return;
    }

    final Map<String, dynamic> data = jsonDecode(jsonText);
    final measurement = Measurement.fromJson(data);

    _openCriticalMeasurementScreen(measurement);
  }

  /// Opens the critical measurement screen on top of the current screen.
  /// This allows critical alerts to interrupt the current workflow.
  void _openCriticalMeasurementScreen(Measurement measurement) {
    appNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => CriticalMeasurementScreen(
          measurement: measurement,
        ),
      ),
    );
  }

  /// Disconnects from the SSE stream.
  /// Called when the healthcare worker signs off.
  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;

    _client?.close();
    _client = null;
  }
}