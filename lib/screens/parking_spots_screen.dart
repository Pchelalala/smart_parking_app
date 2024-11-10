import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/floot_selector.dart';
import '../components/parking_slot_widget.dart';
import '../models/parking_slot_model.dart';

class ParkingSpotsScreen extends StatefulWidget {
  const ParkingSpotsScreen({super.key});

  @override
  State<ParkingSpotsScreen> createState() => _ParkingSpotsScreenState();
}

class _ParkingSpotsScreenState extends State<ParkingSpotsScreen> {
  Stream<List<ParkingSlotModel>> _fetchParkingSlots() {
    return FirebaseFirestore.instance
        .collection('parking_slots')
        .orderBy('slotName')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ParkingSlotModel.fromSnapshot(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Parking Spots",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/home"),
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Column(
                  children: [
                    Text("Parking Slots", style: TextStyle(fontSize: 20)),
                    FloorSelector(),
                    Text("↓ ENTRANCE ↓"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<ParkingSlotModel>>(
                  stream: _fetchParkingSlots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading parking slots'));
                    }

                    final parkingSlots = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: (parkingSlots.length + 1) ~/ 2,
                      itemBuilder: (context, index) {
                        final slot1 = parkingSlots[index * 2];
                        final slot2 = (index * 2 + 1 < parkingSlots.length)
                            ? parkingSlots[index * 2 + 1]
                            : null;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(child: ParkingSlotWidget(parkingSlot: slot1)),
                              if (slot2 != null) ...[
                                const SizedBox(
                                  width: 60,
                                  child: VerticalDivider(
                                    color: Colors.blue,
                                    thickness: 1,
                                  ),
                                ),
                                Expanded(child: ParkingSlotWidget(parkingSlot: slot2)),
                              ]
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
