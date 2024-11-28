import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetupController {
  Future<bool> isCarPlateUnique(String carPlates) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('carPlates', isEqualTo: carPlates.trim())
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Future<void> saveProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String carPlates,
  }) async {
    if (await isCarPlateUnique(carPlates)) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'carPlates': carPlates.trim(),
        'profileImageUrl': 'https://via.placeholder.com/150',
      });
    } else {
      throw Exception('Номер машины уже зарегистрирован другим пользователем.');
    }
  }
}
