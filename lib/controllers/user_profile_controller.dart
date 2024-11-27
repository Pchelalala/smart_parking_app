import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserProfileController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> fetchUserProfile() async {
    final userId = _firebaseAuth.currentUser?.uid;

    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromSnapshot(userDoc);
      }
    }
    return null;
  }

  void signOut(Function onSuccess) {
    _firebaseAuth.signOut();
    onSuccess();
  }
}
