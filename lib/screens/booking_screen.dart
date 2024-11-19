import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_parking_app/features/payment/stripe_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_app/screens/receipt_screen.dart';
import '../models/receipt_model.dart';

class BookingPage extends StatefulWidget {
  final String slotName;
  const BookingPage({super.key, required this.slotName});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  double parkingHours = 10;
  double amountPay = 0;
  bool _isBooked = false;

  Future<bool> checkActiveBooking(String carPlates) async {
    final now = DateTime.now();

    // Получаем все бронирования для указанного номера машины
    final querySnapshot = await FirebaseFirestore.instance
        .collection('receipts')
        .where('userCarPlate', isEqualTo: carPlates)
        .get();

    // Фильтруем только те, которые активны (по endTime)
    final filteredDocs = querySnapshot.docs.where((doc) {
      final endTime = (doc['endTime'] as Timestamp).toDate();
      return endTime.isAfter(now);
    }).toList();

    // Если есть активные бронирования, возвращаем true
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

  Future<void> _bookSpot() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to book a spot.')),
      );
      return;
    }

    try {
      final carPlates = await fetchCarPlates();

      // Проверка активных бронирований
      final hasActiveBooking = await checkActiveBooking(carPlates);
      if (hasActiveBooking) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already have an active booking.')),
        );
        return;
      }

      // Остальная логика бронирования
      setState(() {
        _isBooked = true;
      });

      final receipt = ReceiptModel(
        parkingSpotName: widget.slotName,
        userCarPlate: carPlates,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        amountPaid: 10.0,
      );

      // Платеж
      final bool paymentSuccess = await StripeService.instance.makePayment();
      if (!paymentSuccess) {
        throw Exception('Payment failed');
      }

      // Сохранение данных
      await FirebaseFirestore.instance
          .collection('receipts')
          .add(receipt.toJson());

      // Навигация на следующий экран
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScreen(receipt: receipt),
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booked successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBooked = false;
        });
      }
    }
  }

  void amountCalculator() {
    setState(() {
      amountPay = parkingHours * 10;
    });
  }

  void updateData(String slotId) {
    // Add update logic here
    if (kDebugMode) {
      print("Booking slot with ID: $slotId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Booking",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation/running_car.json',
                      width: 300,
                      height: 200,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text(
                      "Book Now 😊",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.blue,
                ),
                const SizedBox(height: 50),
                const Row(
                  children: [
                    Text("Choose Slot Time (in Minutes)"),
                  ],
                ),
                const SizedBox(height: 10),
                Slider(
                  thumbColor: Colors.blue,
                  activeColor: Colors.blue,
                  inactiveColor: const Color(0xFFD1D9E6),
                  label: parkingHours.toString(),
                  value: parkingHours,
                  onChanged: (value) {
                    setState(() {
                      parkingHours = value;
                      amountCalculator();
                    });
                  },
                  divisions: 5,
                  min: 10,
                  max: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("10"),
                      Text("20"),
                      Text("30"),
                      Text("40"),
                      Text("50"),
                      Text("60"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Slot Name"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          widget.slotName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Row(
                          children: [
                            Text("Amount to Be Paid"),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_pound,
                              size: 30,
                              color: Colors.blue,
                            ),
                            Text(
                              amountPay.toString(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _bookSpot();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "PAY NOW",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
