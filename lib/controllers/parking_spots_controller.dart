import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot_model.dart';

class ParkingSpotsController {
  Stream<List<ParkingSlotModel>> fetchParkingSlots() {
    return FirebaseFirestore.instance
        .collection('parking_slots')
        .orderBy('slotName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSlotModel.fromSnapshot(doc))
            .toList());
  }
}
