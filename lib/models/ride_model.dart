import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final String id;
  final String userId;
  final String name;
  final String contactNumber;
  final String vehicleModel;
  final String vehicleColor;
  final String vehicleYear;
  final String pickupLocation;
  final String dropLocation;
  final DateTime departureTime;
  final int seatsAvailable;
  final List<Reservation> reservations;
  final String fare;

  Ride({
    required this.id,
    required this.userId,
    required this.name,
    required this.contactNumber,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehicleYear,
    required this.pickupLocation,
    required this.dropLocation,
    required this.departureTime,
    required this.seatsAvailable,
    required this.fare,
    this.reservations = const [],
  });

  factory Ride.fromMap(Map<String, dynamic> map, String id) {
    return Ride(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      vehicleModel: map['vehicleModel'] ?? '',
      vehicleColor: map['vehicleColor'] ?? '',
      vehicleYear: map['vehicleYear'] ?? '',
      pickupLocation: map['pickupLocation'] ?? '',
      fare: map['fare'] ?? '',
      dropLocation: map['dropLocation'] ?? '',
      departureTime: (map['departureTime'] is Timestamp)
          ? (map['departureTime'] as Timestamp).toDate()
          : DateTime.tryParse(map['departureTime'].toString()) ??
                DateTime.now(),
      seatsAvailable: (map['seatsAvailable'] as num?)?.toInt() ?? 0,
      reservations: map['reservations'] != null
          ? (map['reservations'] as List)
                .map((res) => Reservation.fromJson(res))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'contactNumber': contactNumber,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'vehicleYear': vehicleYear,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'departureTime': Timestamp.fromDate(departureTime),
      'seatsAvailable': seatsAvailable,
      'fare': fare,
      'createdAt': FieldValue.serverTimestamp(),
      // store reservations inline only if needed
      'reservations': reservations.map((r) => r.toJson()).toList(),
    };
  }

  Ride copyWith({List<Reservation>? reservations}) {
    return Ride(
      id: id,
      userId: userId,
      fare: fare,
      name: name,
      contactNumber: contactNumber,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      vehicleYear: vehicleYear,
      pickupLocation: pickupLocation,
      dropLocation: dropLocation,
      departureTime: departureTime,
      seatsAvailable: seatsAvailable,
      reservations: reservations ?? this.reservations,
    );
  }
}

class Reservation {
  final String userId;
  final String userName;
  final String userContact;
  final int seatsReserved;
  String status; // "pending", "accepted", "rejected"

  Reservation({
    required this.userId,
    required this.userName,
    required this.userContact,
    required this.seatsReserved,
    this.status = "pending",
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    userId: json['userId'] ?? '',
    userName: json['userName'] ?? '',
    userContact: json['userContact'] ?? '',
    seatsReserved: (json['seatsReserved'] as num?)?.toInt() ?? 1,
    status: json['status'] ?? "pending",
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'userContact': userContact,
    'seatsReserved': seatsReserved,
    'status': status,
  };
}
