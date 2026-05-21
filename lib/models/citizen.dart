/// Model class representing a citizen.
/// The model is used to convert JSON from the backend into a Dart object.
class Citizen {
  final String id;
  final String fullName;
  final String address;
  final String phoneNumber;

  const Citizen({
    required this.id,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
  });

  /// Creates a Citizen object from backend JSON.
  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['id'].toString(),
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}