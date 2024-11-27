import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/receipt_model.dart';

class ParkingHistoryController {
  Future<String?> getUserCarPlate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return userDoc['carPlates'];
      }
    }
    return null;
  }

  Stream<List<ReceiptModel>> getReceiptsForCarPlate(String carPlate) {
    return FirebaseFirestore.instance
        .collection('receipts')
        .where('userCarPlate', isEqualTo: carPlate)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ReceiptModel.fromSnapshot(doc))
          .toList();
    });
  }
}
