import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final String parkingSpotName;
  final String userCarPlate;
  final DateTime startTime;
  final DateTime endTime;
  final double amountPaid;
  final String transactionId;

  ReceiptModel({
    required this.parkingSpotName,
    required this.userCarPlate,
    required this.startTime,
    required this.endTime,
    required this.amountPaid,
    required this.transactionId,
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
      transactionId: snapshot['transactionId'],
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
      'transactionId': transactionId,
    };
  }
}
