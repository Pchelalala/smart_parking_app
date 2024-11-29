import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_app/screens/user_reviews_screen.dart';
import '../models/review_model.dart';

class ReviewController {
  late BuildContext _context;

  final TextEditingController reviewTextController = TextEditingController();
  int rating = 0;
  bool isSubmitting = false;

  void initialize(BuildContext context) {
    _context = context;
  }

  void dispose() {
    reviewTextController.dispose();
  }

  void setRating(int newRating) {
    rating = newRating;
  }

  Future<String> fetchUsername() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return snapshot.data()?['firstName'] ?? 'Anonymous';
    }
    return 'Anonymous';
  }

  Future<void> submitReview() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to leave a review.'),
        ),
      );
      return;
    }

    if (rating == 0) {
      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a star rating before submitting.'),
        ),
      );
      return;
    }

    isSubmitting = true;

    final firstName = await fetchUsername();
    final review = ReviewModel(
      userId: userId,
      firstName: firstName,
      reviewText: reviewTextController.text,
      stars: rating,
      date: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('reviews').add(review.toJson());

    isSubmitting = false;

    ScaffoldMessenger.of(_context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully!')),
    );
    Navigator.pop(_context);
  }
}
