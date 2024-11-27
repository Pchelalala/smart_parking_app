import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class EditProfileController {
  final UserModel user;

  EditProfileController(this.user);

  Future<void> saveProfile(
      String firstName, String lastName, String carPlates) async {
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
