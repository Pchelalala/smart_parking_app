import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final String parkingSpotName;
  final String userCarPlate;
  final DateTime startTime;
  final DateTime endTime;
  final double amountPaid;

  ReceiptModel({
    required this.parkingSpotName,
    required this.userCarPlate,
    required this.startTime,
    required this.endTime,
    required this.amountPaid,
  });

  // Convert Firestore document data to UserModel
  static ReceiptModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ReceiptModel(
      parkingSpotName: snapshot['parkingSpotName'],
      userCarPlate: snapshot['userCarPlate'],
      startTime: (snapshot['startTime'] as Timestamp).toDate(),
      endTime: (snapshot['endTime'] as Timestamp).toDate(),
      amountPaid: snapshot['amountPaid'],
    );
  }

  // Convert UserModel to a Map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'parkingSpotName': parkingSpotName,
      'userCarPlate': userCarPlate,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'amountPaid': amountPaid,
    };
  }
}
