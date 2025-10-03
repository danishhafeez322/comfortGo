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
  });

  factory Ride.fromMap(Map<String, dynamic> map, String id) {
    return Ride(
      id: id,
      userId: map['userId'],
      name: map['name'],
      contactNumber: map['contactNumber'],
      vehicleModel: map['vehicleModel'],
      vehicleColor: map['vehicleColor'],
      vehicleYear: map['vehicleYear'],
      pickupLocation: map['pickupLocation'],
      dropLocation: map['dropLocation'],
      departureTime: (map['departureTime'] as Timestamp).toDate(),
      seatsAvailable: map['seatsAvailable'],
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
      'departureTime': departureTime,
      'seatsAvailable': seatsAvailable,
      'createdAt': DateTime.now(),
    };
  }
}
