import 'package:flutter/material.dart';
import '../models/citizen.dart';
import '../services/citizen_service.dart';
import '../widgets/citizen_card.dart';
import 'citizen_detail_screen.dart';

/// Screen that shows all citizens.
/// This is the normal screen shown after login.
class CitizenListScreen extends StatefulWidget {
  final String token;

  const CitizenListScreen({
    super.key,
    required this.token,
  });

  @override
  State<CitizenListScreen> createState() => _CitizenListScreenState();
}

/// State class for CitizenListScreen.
/// It stores the list of citizens loaded from the backend.
class _CitizenListScreenState extends State<CitizenListScreen> {
  final CitizenService citizenService = CitizenService();

  List<Citizen> citizens = [];
  bool isLoading = true;
  String? errorMessage;

  /// Loads citizens when the screen opens.
  @override
  void initState() {
    super.initState();
    loadCitizens();
  }

  /// Fetches citizens from the service layer and updates the UI.
  Future<void> loadCitizens() async {
    try {
      final result = await citizenService.getCitizens(widget.token);

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

  /// Opens the detail screen for the selected citizen.
  void openCitizenDetails(Citizen citizen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitizenDetailScreen(
          citizen: citizen,
          token: widget.token,
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
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizens'),
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