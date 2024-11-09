import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_app/screens/parking_spots_screen.dart';
import '../models/parking_place_model.dart';

class ParkingsScreen extends StatefulWidget {
  const ParkingsScreen({super.key});

  @override
  State<ParkingsScreen> createState() => _ParkingsScreenState();
}

class _ParkingsScreenState extends State<ParkingsScreen> {
  void _navigateToProfile() {
    Navigator.pushNamed(context, '/home');
  }

  void _navigateToParkingSpotsScreen(String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ParkingSpotsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parking Places',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('parking_places').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No parking places available.'));
          }

          final parkingPlaces = snapshot.data!.docs.map((doc) {
            return ParkingPlaceModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();

          return ListView.builder(
            itemCount: parkingPlaces.length,
            itemBuilder: (context, index) {
              final parking = parkingPlaces[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Image.network(
                    parking.imageUrl ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(parking.address ?? 'Unknown Address'),
                  onTap: () =>
                      _navigateToParkingSpotsScreen(parking.address ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
