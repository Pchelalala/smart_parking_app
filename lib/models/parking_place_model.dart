import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingPlaceModel {
  String? imageUrl;
  String? address;

  ParkingPlaceModel({this.imageUrl, this.address});

  // Convert Firestore document data to UserModel
  static ParkingPlaceModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ParkingPlaceModel(
      imageUrl: snapshot['imageUrl'],
      address: snapshot['address'],
    );
  }

  // Convert UserModel to a Map for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'address': address,
    };
  }
}
