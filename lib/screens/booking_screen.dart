import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_parking_app/controllers/booking_controller.dart';
import 'package:smart_parking_app/screens/receipt_screen.dart';

class BookingScreen extends StatefulWidget {
  final String slotName;
  const BookingScreen({super.key, required this.slotName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  double parkingHours = 1;
  double amountPay = 1.50;
  bool _isBooked = false;
  String selectedPaymentMethod = 'stripe'; // Default payment method
  String? selectedCryptoCurrency; // For crypto payments

  final BookingController _bookingController = BookingController();

  void amountCalculator() {
    setState(() {
      amountPay = parkingHours * 1.50;
    });
  }

  Future<void> _bookSpot() async {
    setState(() {
      _isBooked = true;
    });

    await _bookingController.bookSpot(
      slotName: widget.slotName,
      amountPaid: amountPay,
      parkingHours: parkingHours,
      paymentMethod: selectedPaymentMethod,
      cryptoCurrency: selectedCryptoCurrency,
      onError: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $message')),
        );
        setState(() {
          _isBooked = false;
        });
      },
      onSuccess: (receipt) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScreen(receipt: receipt),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booked successfully!')),
        );
      },
    );

    setState(() {
      _isBooked = false;
    });
  }

  @override
  void initState() {
    super.initState();
    amountCalculator();
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
                      "Book Now!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const Divider(thickness: 1, color: Colors.blue),
                const SizedBox(height: 50),
                const Row(
                  children: [
                    Text("Choose Slot Time (in Hours)"),
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
                  min: 1,
                  max: 6,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1"),
                      Text("2"),
                      Text("3"),
                      Text("4"),
                      Text("5"),
                      Text("6"),
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
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Text("Select Payment Method"),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  items: const [
                    DropdownMenuItem(
                      value: 'stripe',
                      child: Text('Card Payment'),
                    ),
                    DropdownMenuItem(
                      value: 'crypto',
                      child: Text('Crypto Payment'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                      if (selectedPaymentMethod == 'stripe') {
                        selectedCryptoCurrency = null;
                      }
                    });
                  },
                ),
                if (selectedPaymentMethod == 'crypto')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: selectedCryptoCurrency,
                        hint: const Text("Choose Crypto"),
                        items: const [
                          DropdownMenuItem(
                            value: 'BTC',
                            child: Text('Bitcoin (BTC)'),
                          ),
                          DropdownMenuItem(
                            value: 'ETH',
                            child: Text('Ethereum (ETH)'),
                          ),
                          DropdownMenuItem(
                            value: 'USDT',
                            child: Text('Tether (USDT)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCryptoCurrency = value;
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
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
                            const Icon(FontAwesomeIcons.euroSign,
                                size: 30, color: Colors.blue),
                            Text(
                              amountPay.toStringAsFixed(2),
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
                      onPressed: _isBooked ? null : _bookSpot,
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
