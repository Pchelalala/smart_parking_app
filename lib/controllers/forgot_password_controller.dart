import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> resetPassword(String email) async {
    if (email.isEmpty) {
      return 'Please enter your email.';
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent. Check your inbox.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email address is invalid.';
      } else if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      } else {
        return 'An error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
