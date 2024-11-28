import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class EditProfileController {
  final UserModel user;

  EditProfileController(this.user);

  Future<bool> isCarPlateUnique(String carPlates) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('carPlates', isEqualTo: carPlates)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.id != FirebaseAuth.instance.currentUser!.uid) {
        return false;
      }
    }
    return true;
  }

  Future<void> saveProfile(
      String firstName, String lastName, String carPlates) async {
    final isUnique = await isCarPlateUnique(carPlates);
    if (!isUnique) {
      throw Exception('Car plates already registered by another user.');
    }

    final updatedUser = UserModel(
      firstName: firstName,
      lastName: lastName,
      carPlates: carPlates,
      profileImageUrl: user.profileImageUrl,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(updatedUser.toJson());
  }
}
