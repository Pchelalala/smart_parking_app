import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_app/screens/receipt_screen.dart';
import '../models/receipt_model.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({super.key});

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  // Получаем информацию о текущем пользователе
  String? currentUserCarPlate;

  @override
  void initState() {
    super.initState();
    _getUserCarPlate();
  }

  // Получаем номер машины текущего пользователя
  Future<void> _getUserCarPlate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Получаем номер машины пользователя из Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          currentUserCarPlate = userDoc['carPlates']; // Предположим, что в Firestore у пользователя есть поле carPlate
        });
      }
    }
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/home');
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
      // Пока мы не получили номер машины, показываем индикатор загрузки
      return const Center(child: CircularProgressIndicator());
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .where('userCarPlate', isEqualTo: currentUserCarPlate) // Фильтрация по номеру машины
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No receipts available.'));
          }

          final receipts = snapshot.data!.docs.map((doc) {
            return ReceiptModel.fromSnapshot(doc);
          }).toList();

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