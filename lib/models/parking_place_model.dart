import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingPlaceModel {
  final String? imageUrl;
  final String? address;
  final double? latitude;
  final double? longitude;

  ParkingPlaceModel({
    this.imageUrl,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory ParkingPlaceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Snapshot data is null');
    }

    final GeoPoint? geoPoint = data['coordinates'] as GeoPoint?;

    return ParkingPlaceModel(
      imageUrl: data['imageUrl'] as String?,
      address: data['address'] as String?,
      latitude: geoPoint?.latitude,
      longitude: geoPoint?.longitude,
    );
  }
}
