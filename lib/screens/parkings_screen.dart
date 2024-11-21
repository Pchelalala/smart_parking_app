import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_app/screens/parking_spots_screen.dart';
import 'package:smart_parking_app/screens/user_reviews_screen.dart';
import '../features/gps_navigation/navigation_helper.dart';
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

  void _navigateToUserReviewsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserReviewsScreen(),
      ),
    );
  }

  void _navigateToSpot(double latitude, double longitude) {
    try {
      NavigationHelper.openMap(latitude, longitude);
    } catch (e) {
      print('Failed to open map: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to open map'),
        ),
      );
    }
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
            icon: const Icon(Icons.person, color: Colors.white),
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
                margin: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (parking.address != null) {
                            _navigateToParkingSpotsScreen(parking.address!);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                parking.imageUrl ?? '',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parking.address ?? 'Unknown Address',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (parking.latitude != null &&
                                    parking.longitude != null) {
                                  _navigateToSpot(
                                      parking.latitude!, parking.longitude!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Location data is not available'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Navigate to Spot',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _navigateToUserReviewsScreen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Customer Reviews',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
