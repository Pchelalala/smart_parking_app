import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSlotModel {
  final bool isBooked;
  final String slotName;
  final String slotId;
  final String time;

  ParkingSlotModel({
    required this.isBooked,
    required this.slotName,
    this.slotId = "0.0",
    required this.time,
  });

  // Convert Firestore document data to ParkingSlotModel
  static ParkingSlotModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ParkingSlotModel(
      isBooked: snapshot['isBooked'] as bool,
      slotName: snapshot['slotName'] as String,
      slotId: snapshot['slotId'] as String? ?? "0.0",
      time: snapshot['time'] as String? ?? "",
    );
  }

  // Convert ParkingSlotModel to a Map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'isBooked': isBooked,
      'slotName': slotName,
      'slotId': slotId,
      'time': time,
    };
  }
}
