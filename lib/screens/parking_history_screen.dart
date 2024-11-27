import 'package:flutter/material.dart';
import '../controllers/parking_history_controller.dart';
import '../models/receipt_model.dart';
import 'receipt_screen.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({super.key});

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  final ParkingHistoryController _controller = ParkingHistoryController();
  String? currentUserCarPlate;

  @override
  void initState() {
    super.initState();
    _loadUserCarPlate();
  }

  Future<void> _loadUserCarPlate() async {
    final carPlate = await _controller.getUserCarPlate();
    setState(() {
      currentUserCarPlate = carPlate;
    });
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  void _navigateToReceiptDetails(ReceiptModel receipt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(receipt: receipt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserCarPlate == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parking History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: StreamBuilder<List<ReceiptModel>>(
        stream: _controller.getReceiptsForCarPlate(currentUserCarPlate!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No receipts available.'));
          }

          final receipts = snapshot.data!;
          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: ListTile(
                  title: Text(receipt.parkingSpotName),
                  subtitle: Text(
                    'Paid: \$${receipt.amountPaid.toStringAsFixed(2)} | '
                    'Plate: ${receipt.userCarPlate}',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _navigateToReceiptDetails(receipt),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
