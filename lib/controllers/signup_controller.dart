import 'package:firebase_auth/firebase_auth.dart';
import '../features/user_auth/firebase_auth_service.dart';
import '../components/toast.dart';

class SignUpController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool isSigningUp = false;

  Future<User?> signUp(String email, String password) async {
    isSigningUp = true;

    User? user = await _authService.signUpWithEmailAndPassword(email, password);

    isSigningUp = false;
    return user;
  }
}
