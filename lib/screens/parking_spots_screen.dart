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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Parking spots",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/home"),
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Parking Slots", style: TextStyle(fontSize: 20)),
                        FloorSelector(),
                        Text("↓ ENTRANCE ↓"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('parking_slots')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error loading parking slots'));
                    }

                    // Map Firestore documents to ParkingSlotModel instances
                    final parkingSlots = snapshot.data?.docs
                            .map((doc) => ParkingSlotModel.fromSnapshot(doc))
                            .toList() ??
                        [];

                    return Column(
                      children: [
                        for (int i = 0; i < parkingSlots.length; i += 2)
                          Row(
                            children: [
                              Expanded(
                                child: ParkingSlotWidget(
                                    parkingSlot: parkingSlots[i]),
                              ),
                              if (i + 1 < parkingSlots.length) ...[
                                const SizedBox(
                                  width: 60,
                                  child: VerticalDivider(
                                    color: Colors.blue,
                                    thickness: 1,
                                  ),
                                ),
                                Expanded(
                                  child: ParkingSlotWidget(
                                      parkingSlot: parkingSlots[i + 1]),
                                ),
                              ]
                            ],
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
