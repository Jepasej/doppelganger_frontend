import 'package:flutter/material.dart';
import '../models/citizen.dart';

/// Reusable widget for showing one citizen in a list.
/// StatelessWidget is used because the widget only receives and displays data.
class CitizenCard extends StatelessWidget {
  final Citizen citizen;
  final VoidCallback onTap;

  const CitizenCard({
    super.key,
    required this.citizen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: const Icon(
          Icons.person,
          color: Colors.blue,
        ),
        title: Text(citizen.fullName),
        subtitle: Text(
          '${citizen.address}\n${citizen.phoneNumber}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}