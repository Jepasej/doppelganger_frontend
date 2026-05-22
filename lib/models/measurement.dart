/// Model class representing one vital measurement.

/// Measurements are sent from Raspberry Pi to backend and then to Flutter.
class Measurement {
  final String id;
  final String citizenId;
  final String citizenName;
  final String citizenPhoneNumber;
  final int pulse;
  final double spo2;
  final DateTime createdAt;
  final bool isCritical;

  const Measurement({
    required this.id,
    required this.citizenId,
    required this.citizenName,
    required this.citizenPhoneNumber,
    required this.pulse,
    required this.spo2,
    required this.createdAt,
    required this.isCritical,
  });

  /// Creates a Measurement object from backend JSON.
  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'].toString(),
      citizenId: json['citizenId'].toString(),
      citizenName: json['citizenName'] ?? 'Unknown citizen',
      citizenPhoneNumber: json['citizenPhoneNumber'] ?? '',
      pulse: json['pulse'],
      spo2: (json['spo2'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      isCritical: json['isCritical'] ?? false,
    );
  }
}