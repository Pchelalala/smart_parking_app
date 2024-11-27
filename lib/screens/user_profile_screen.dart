import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/toast.dart';
import '../controllers/user_profile_controller.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'parking_history_screen.dart';
import 'profile_setup_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController _controller = UserProfileController();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await _controller.fetchUserProfile();
    if (user != null) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSetupScreen(
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ),
      );
    }
  }

  void _onSignOut() {
    _controller.signOut(() {
      Navigator.pushReplacementNamed(context, "/login");
      showToast(message: "Successfully signed out");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user != null
              ? _buildProfileUI()
              : const Center(child: Text("Error loading profile")),
    );
  }

  Widget _buildProfileUI() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_user!.profileImageUrl ??
                    'https://via.placeholder.com/150'),
                backgroundColor: Colors.blue.shade100,
              ),
              const SizedBox(height: 20),
              Text(
                '${_user!.firstName} ${_user!.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Car Plates: ${_user!.carPlates}',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              _buildButton('Edit Profile', Colors.blue, () async {
                final updatedUser = await Navigator.push<UserModel>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: _user!),
                  ),
                );
                if (updatedUser != null) {
                  setState(() {
                    _user = updatedUser;
                  });
                }
              }),
              _buildButton('View Parking History', Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParkingHistoryScreen(),
                  ),
                );
              }),
              _buildButton('Sign Out', Colors.red, _onSignOut),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(backgroundColor: color),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
