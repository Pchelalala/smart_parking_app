import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetupController {
  Future<void> saveProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String carPlates,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'carPlates': carPlates.trim(),
      'profileImageUrl': 'https://via.placeholder.com/150',
    });
  }
}
