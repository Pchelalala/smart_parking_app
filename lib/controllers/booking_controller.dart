import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/receipt_model.dart';
import '../features/payment/stripe_services.dart';

class BookingController {
  Future<bool> checkActiveBooking(String carPlates) async {
    final now = DateTime.now();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('receipts')
        .where('userCarPlate', isEqualTo: carPlates)
        .get();

    final filteredDocs = querySnapshot.docs.where((doc) {
      final endTime = (doc['endTime'] as Timestamp).toDate();
      return endTime.isAfter(now);
    }).toList();

    return filteredDocs.isNotEmpty;
  }

  Future<String> fetchCarPlates() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return snapshot.data()?['carPlates'] ?? 'Anonymous';
    }
    return 'Anonymous';
  }

  Future<void> bookSpot({
    required String slotName,
    required double amountPaid,
    required double parkingHours,
    required Function(String message) onError,
    required Function(ReceiptModel receipt) onSuccess,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      onError('You must be logged in to book a spot.');
      return;
    }

    try {
      final carPlates = await fetchCarPlates();
      final hasActiveBooking = await checkActiveBooking(carPlates);
      if (hasActiveBooking) {
        onError('You already have an active booking.');
        return;
      }

      final receipt = ReceiptModel(
        parkingSpotName: slotName,
        userCarPlate: carPlates,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: parkingHours.toInt())),
        amountPaid: amountPaid,
      );

      final qrData = receipt.qrData;

      final bool paymentSuccess = await StripeService.instance
          .makePayment(amount: (amountPaid * 100).toInt());
      if (!paymentSuccess) {
        throw Exception('Payment failed');
      }

      await FirebaseFirestore.instance.collection('receipts').add({
        ...receipt.toJson(),
        'qrData': qrData,
      });

      final slotsCollection =
          FirebaseFirestore.instance.collection('parking_slots');
      final querySnapshot =
          await slotsCollection.where('slotName', isEqualTo: slotName).get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Slot "$slotName" is not found.');
      }

      final slotId = querySnapshot.docs.first.id;
      await slotsCollection.doc(slotId).update({'isBooked': true});

      onSuccess(receipt);
    } catch (e) {
      onError(e.toString());
    }
  }
}
