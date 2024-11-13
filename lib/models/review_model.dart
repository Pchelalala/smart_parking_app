import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userId;
  final String firstName;
  final String reviewText;
  final int stars;
  final DateTime date;

  ReviewModel({
    required this.userId,
    required this.firstName,
    required this.reviewText,
    required this.stars,
    required this.date,
  });

  // Convert Firestore document data to UserModel
  static ReviewModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ReviewModel(
      userId: snapshot['userId'],
      firstName: snapshot['firstName'],
      reviewText: snapshot['reviewText'],
      stars: snapshot['stars'],
      date: (snapshot['date'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel to a Map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'reviewText': reviewText,
      'stars': stars,
      'date': date,
    };
  }
}
