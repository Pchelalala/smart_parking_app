import 'package:flutter/material.dart';

class UserReviewsScreen extends StatefulWidget {
  const UserReviewsScreen({super.key});

  @override
  State<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {
  final List<Map<String, dynamic>> reviews = [
    {
      'username': 'Alice',
      'reviewText': 'Great parking spot, very convenient!',
      'stars': 5,
    },
    {
      'username': 'Bob',
      'reviewText': 'It was okay, but a bit crowded.',
      'stars': 3,
    },
    {
      'username': 'Charlie',
      'reviewText': 'Not very clean and hard to park.',
      'stars': 2,
    },
  ];

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/home');
  }

  // Helper function to generate star widgets based on rating
  List<Widget> _buildStarRating(int starCount) {
    return List.generate(5, (index) {
      return Icon(
        index < starCount ? Icons.star : Icons.star_border,
        color: Colors.amber,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Reviews',
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
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: _buildStarRating(review['stars']),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    review['reviewText'],
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
