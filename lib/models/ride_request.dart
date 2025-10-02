class RideRequest {
  final String id;
  final String passengerName;
  final String contactNumber;
  final String pickupLocation;
  final String destination;
  final DateTime time;
  final int seatsNeeded;
  final DateTime createdAt;
  final bool isCompleted;
  final String ownerId;

  RideRequest({
    required this.id,
    required this.passengerName,
    required this.contactNumber,
    required this.pickupLocation,
    required this.destination,
    required this.time,
    required this.seatsNeeded,
    required this.createdAt,
    required this.isCompleted,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "passengerName": passengerName,
      "contactNumber": contactNumber,
      "pickupLocation": pickupLocation,
      "destination": destination,
      "time": time.toIso8601String(),
      "seatsNeeded": seatsNeeded,
      "createdAt": createdAt.toIso8601String(),
      "isCompleted": isCompleted,
      "ownerId": ownerId,
    };
  }

  factory RideRequest.fromJson(Map<String, dynamic> json, String id) {
    return RideRequest(
      id: id,
      passengerName: json["passengerName"] ?? "",
      contactNumber: json["contactNumber"] ?? "",
      pickupLocation: json["pickupLocation"] ?? "",
      destination: json["destination"] ?? "",
      time: DateTime.parse(json["time"]),
      seatsNeeded: json["seatsNeeded"] ?? 1,
      createdAt: DateTime.parse(json["createdAt"]),
      isCompleted: json["isCompleted"] ?? false,
      ownerId: json["ownerId"] ?? "",
    );
  }
}
