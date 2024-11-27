import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_parking_app/screens/parkings_screen.dart';
import '../controllers/profile_setup_controller.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String userId;

  const ProfileSetupScreen({super.key, required this.userId});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _carPlatesController = TextEditingController();
  final ProfileSetupController _controller = ProfileSetupController();
  bool _isSaving = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _controller.saveProfile(
        userId: widget.userId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        carPlates: _carPlatesController.text,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error saving profile: $e");
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ParkingsScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setup Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your first name'
                    : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your last name'
                    : null,
              ),
              TextFormField(
                controller: _carPlatesController,
                decoration: const InputDecoration(labelText: 'Car Plates'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your car plates'
                    : null,
              ),
              const SizedBox(height: 20),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Profile'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
