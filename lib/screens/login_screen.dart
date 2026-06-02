import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/sse_service.dart';
import 'citizen_list_screen.dart';

/// Login screen for healthcare staff.
/// Healthcare workers authenticate through the NestJS backend using JWT.
/// StatefulWidget is used because the input fields and loading state can change.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// State class for LoginScreen.
/// This class stores controllers, loading state and error messages.
class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  /// Logs in the healthcare worker through the backend.
  /// If login succeeds, tokens are stored securely and SSE connection is started.
  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await authService.login(
        usernameController.text,
        passwordController.text,
      );

      await SseService.instance.connect();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CitizenListScreen(),
        ),
      );
    } catch (error) {
      setState(() {
        errorMessage = 'Login failed. Check username and password.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Disposes controllers when the screen is removed.
  /// This helps prevent memory leaks.
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Doppelgaenger',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Semantics(
                    label: 'Email input',
                    textField: true,
                    child: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Semantics(
                    label: 'Password input',
                    textField: true,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 16),

                  Semantics(
                    label: 'Login button',
                    button: true,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}