import 'package:flutter/material.dart';
import '../models/receipt_model.dart';

class ReceiptScreen extends StatelessWidget {
  final ReceiptModel receipt;

  const ReceiptScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receipt")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Parking place: ${receipt.parkingSpotName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Car plate: ${receipt.userCarPlate}"),
            Text("Start time: ${receipt.startTime}"),
            Text("End time: ${receipt.endTime}"),
            Text("Amount: ${receipt.amountPaid.toStringAsFixed(2)} ₽"),
            Text("Transaction ID: ${receipt.transactionId}"),
          ],
        ),
      ),
    );
  }
}
