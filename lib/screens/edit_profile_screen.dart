import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({required this.user, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String carPlates;

  @override
  void initState() {
    super.initState();
    firstName = widget.user.firstName ?? '';
    lastName = widget.user.lastName ?? '';
    carPlates = widget.user.carPlates ?? '';
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Update the user data
      final updatedUser = UserModel(
        firstName: firstName,
        lastName: lastName,
        carPlates: carPlates,
        profileImageUrl: widget.user.profileImageUrl,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(updatedUser.toJson());

      Navigator.pop(context, updatedUser); // Return updated user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                onChanged: (value) => firstName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a first name' : null,
              ),
              TextFormField(
                initialValue: lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => lastName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a last name' : null,
              ),
              TextFormField(
                initialValue: carPlates,
                decoration: const InputDecoration(labelText: 'Car Plates'),
                onChanged: (value) => carPlates = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter car plates' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
