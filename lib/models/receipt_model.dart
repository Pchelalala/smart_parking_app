import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final String parkingSpotName;
  final String userCarPlate;
  final DateTime startTime;
  final DateTime endTime;
  final double amountPaid;
  final String qrData;

  ReceiptModel({
    required this.parkingSpotName,
    required this.userCarPlate,
    required this.startTime,
    required this.endTime,
    required this.amountPaid,
  }) : qrData =
            'Parking Spot: $parkingSpotName\nCar Plate: $userCarPlate\nStart Time: $startTime\nEnd Time: $endTime\nAmount Paid: $amountPaid Є';

  // Конвертация Firestore документа в модель
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

  // Конвертация модели в Map для сохранения в Firestore
  Map<String, dynamic> toJson() {
    return {
      'parkingSpotName': parkingSpotName,
      'userCarPlate': userCarPlate,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'amountPaid': amountPaid,
      'qrData': qrData, // Сохранение данных QR-кода
    };
  }
}
