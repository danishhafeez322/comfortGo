class Trip {
  final String id;
  final String driverName;
  final String pickupLocation;
  final String dropLocation;
  final DateTime departureTime;
  final int seatsAvailable;

  Trip({
    required this.id,
    required this.driverName,
    required this.pickupLocation,
    required this.dropLocation,
    required this.departureTime,
    required this.seatsAvailable,
  });

  factory Trip.fromJson(Map<String, dynamic> json, String id) {
    return Trip(
      id: id,
      driverName: json['driverName'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropLocation: json['dropLocation'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      seatsAvailable: json['seatsAvailable'] ?? 0,
    );
  }
}
