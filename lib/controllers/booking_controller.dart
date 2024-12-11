import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../models/receipt_model.dart';
import '../features/payment/stripe_service.dart';

class BookingController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api-sandbox.nowpayments.io/v1',
      headers: {
        'x-api-key': '9CRRCN1-VMHM1XE-MAG8W3G-WXHSF5M',
      },
    ),
  );

  Future<List<String>> fetchAvailableCryptoCurrencies() async {
    try {
      final response = await _dio.get('/currencies');
      if (response.statusCode == 200) {
        final currencies = response.data['currencies'] as List<dynamic>;
        return currencies.map((e) => e.toString()).toList();
      } else {
        throw Exception('Failed to fetch currencies: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to fetch currencies: $e');
    }
  }

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

  /// Метод для создания криптовалютного платежа через NOWPayments
  Future<String?> makeCryptoPayment({
    required double amount,
    required String currency,
    required String crypto,
  }) async {
    try {
      final response = await _dio.post('/invoice', data: {
        "price_amount": amount,
        "price_currency": currency,
        "pay_currency": crypto,
        "order_id": "test_order_${DateTime.now().millisecondsSinceEpoch}",
        "order_description": "Booking payment for parking spot",
        "ipn_callback_url":
            "https://webhook.site/c1f3fb2a-4cbd-4912-871e-6203ed6104b3",
      });

      if (response.statusCode == 200) {
        return response.data['invoice_url'];
      } else {
        throw Exception('Error creating payment: ${response.data}');
      }
    } catch (e) {
      throw Exception('Crypto payment failed: $e');
    }
  }

  Future<void> bookSpot({
    required String slotName,
    required double amountPaid,
    required double parkingHours,
    required String paymentMethod,
    required String? cryptoCurrency,
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

      bool paymentSuccess = false;

      if (paymentMethod == "stripe") {
        paymentSuccess = await StripeService.instance
            .makePayment(amount: (amountPaid * 100).toInt());
      } else if (paymentMethod == "crypto" && cryptoCurrency != null) {
        final paymentUrl = await makeCryptoPayment(
          amount: amountPaid,
          currency: "EUR",
          crypto: cryptoCurrency,
        );
        if (paymentUrl != null) {
          onError('Please complete the payment: $paymentUrl');
          return;
        }
      } else {
        throw Exception('Invalid payment method selected');
      }

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
