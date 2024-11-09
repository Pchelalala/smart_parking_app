import 'package:flutter/material.dart';

class ParkingsScreen extends StatefulWidget {
  const ParkingsScreen({super.key});

  @override
  State<ParkingsScreen> createState() => _ParkingsScreenState();
}

class _ParkingsScreenState extends State<ParkingsScreen> {
  // Sample static data for parking places; replace with dynamic data when available
  final List<Map<String, String>> parkingPlaces = [
    {
      'imageUrl':
      'https://media.istockphoto.com/id/480652712/photo/dealer-new-cars-stock.jpg?s=612x612&w=0&k=20&c=Mzfb5oEeovQblEo160df-xFxfd6dGoLBkqjjDWQbd5E=',
      'address': 'Laisvės al. 1, Kaunas',
    },
    {
      'imageUrl':
      'https://preview.redd.it/bkcvp1okq7081.jpg?width=1080&crop=smart&auto=webp&s=40c0c799d2b82c4266942b04c0df009e0e0b05f7',
      'address': 'Vilniaus g. 23, Kaunas',
    },
    {
      'imageUrl': 'https://i.imgur.com/BC6PSsS.jpg',
      'address': 'Karaliaus Mindaugo pr. 50, Kaunas',
    },
    {
      'imageUrl':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4tpDFYZpIeI4AEw8Df0p-JnQQGB5XFOiDCA&s',
      'address': 'Savanorių pr. 15, Kaunas',
    },
  ];

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Places'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: parkingPlaces.length,
        itemBuilder: (context, index) {
          final parking = parkingPlaces[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: Image.network(
                parking['imageUrl']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(parking['address']!),
            ),
          );
        },
      ),
    );
  }
}
