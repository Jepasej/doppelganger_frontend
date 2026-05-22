import 'package:flutter/material.dart';

/// Global navigator key.

/// This makes it possible to open a screen from a service class,
/// for example when a WebSocket event is received.
final GlobalKey<NavigatorState> appNavigatorKey =
    GlobalKey<NavigatorState>();
