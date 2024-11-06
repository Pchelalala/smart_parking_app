import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? carPlates;
  String? profileImageUrl;

  UserModel(
      {this.firstName, this.lastName, this.carPlates, this.profileImageUrl});

  // Convert Firestore document data to UserModel
  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      carPlates: snapshot['carPlates'],
      profileImageUrl: snapshot['profileImageUrl'],
    );
  }

  // Convert UserModel to a Map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'carPlates': carPlates,
      'profileImageUrl': profileImageUrl,
    };
  }
}
