import 'package:firebase_auth/firebase_auth.dart';
import '../../components/toast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validatePassword(String password) {
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasNumeric = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialCharacter =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final bool isLengthValid = password.length >= 8;

    return hasUppercase &&
        hasLowercase &&
        hasNumeric &&
        hasSpecialCharacter &&
        isLengthValid;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      if (!_validatePassword(password)) {
        showToast(
            message: 'Password must be at least 8 characters long, contain '
                'uppercase, lowercase, a number, and a special character.');
        return null;
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}
