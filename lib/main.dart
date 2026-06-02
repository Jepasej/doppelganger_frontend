import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'navigation/app_navigator.dart';
import 'screens/login_screen.dart';

/// Entry point for the Flutter application.
/// This starts the app and shows the login screen first.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enables semantics so Playwright can locate UI elements in Flutter Web.
  SemanticsBinding.instance.ensureSemantics();

  runApp(const DoppelgaengerApp());
}

/// Root widget for the application.
/// This widget is stateless because it only sets up the app structure.
class DoppelgaengerApp extends StatelessWidget {
  const DoppelgaengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Doppelgaenger Frontend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}