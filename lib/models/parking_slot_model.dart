import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSlotModel {
  final bool isBooked;
  final String slotName;

  ParkingSlotModel({
    required this.isBooked,
    required this.slotName,
  });

  // Convert Firestore document data to ParkingSlotModel
  static ParkingSlotModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ParkingSlotModel(
      isBooked: snapshot['isBooked'] as bool,
      slotName: snapshot['slotName'] as String,
    );
  }

  // Convert ParkingSlotModel to a Map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'isBooked': isBooked,
      'slotName': slotName,
    };
  }
}
