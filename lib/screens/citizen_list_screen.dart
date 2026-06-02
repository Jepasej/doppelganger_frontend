import 'package:flutter/material.dart';
import '../models/citizen.dart';
import '../services/auth_service.dart';
import '../services/citizen_service.dart';
import '../widgets/citizen_card.dart';
import 'citizen_detail_screen.dart';

/// Screen displaying all citizens.
/// This is the default screen shown after successful login.
class CitizenListScreen extends StatefulWidget {
  const CitizenListScreen({super.key});

  @override
  State<CitizenListScreen> createState() => _CitizenListScreenState();
}

/// State class for CitizenListScreen.
/// It stores the list of citizens loaded from the backend.
class _CitizenListScreenState extends State<CitizenListScreen> {
  final CitizenService citizenService = CitizenService();
  final AuthService authService = AuthService();

  List<Citizen> citizens = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCitizens();
  }

  /// Fetches citizens through the service layer and updates the UI.
  Future<void> loadCitizens() async {
    try {
      final result = await citizenService.getCitizens();

      setState(() {
        citizens = result;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Could not load citizens';
        isLoading = false;
      });
    }
  }

  /// Calls the backend admin endpoint and shows the result to the user.
  Future<void> checkAdminAccess() async {
    try {
      final hasAdminAccess = await authService.checkAdminAccess();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Admin'),
          content: Text(
            hasAdminAccess
                ? 'Admin adgang bekræftet.'
                : 'Du har ikke adminrettigheder.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Fejl'),
          content: const Text('Admin-adgang kunne ikke kontrolleres.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  /// Opens the detail screen for the selected citizen.
  void openCitizenDetails(Citizen citizen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitizenDetailScreen(
          citizen: citizen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Citizens')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizens'),
        actions: [
          Semantics(
            label: 'Admin button',
            button: true,
            child: TextButton(
              onPressed: checkAdminAccess,
              child: const Text('Admin'),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: citizens.length,
        itemBuilder: (context, index) {
          final citizen = citizens[index];

          return CitizenCard(
            citizen: citizen,
            onTap: () => openCitizenDetails(citizen),
          );
        },
      ),
    );
  }
}