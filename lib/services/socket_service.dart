import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/measurement.dart';
import '../navigation/app_navigator.dart';
import '../screens/critical_measurement_screen.dart';
import 'api_service.dart';

/// Service class responsible for realtime communication.
/// This service listens for critical measurements from the backend.
class SocketService {
  static final SocketService instance = SocketService._internal();

  SocketService._internal();

  io.Socket? socket;
  String? currentToken;

  /// Connects to realtime updates.
  void connect(String token) {
    currentToken = token;

    socket = io.io(
      ApiService.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('Connected to WebSocket');
    });

    socket!.on('critical-measurement', (data) {
      final measurement = Measurement.fromJson(data);

      _openCriticalMeasurementScreen(measurement);
    });

    socket!.onDisconnect((_) {
      debugPrint('Disconnected from WebSocket');
    });
  }

  /// Opens the critical screen no matter which screen the user is currently on.
  void _openCriticalMeasurementScreen(Measurement measurement) {
    appNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => CriticalMeasurementScreen(
          measurement: measurement,
          token: currentToken ?? 'fake-jwt-token',
        ),
      ),
    );
  }

  /// Disconnects from the WebSocket.
  /// This can be used later if the user logs out.
  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    currentToken = null;
  }
}