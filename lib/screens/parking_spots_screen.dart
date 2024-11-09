import 'package:flutter/material.dart';

import '../components/floot_selector.dart';
import '../components/parking_slot_widget.dart';
import '../models/parking_slot_model.dart';

class ParkingSpotsScreen extends StatefulWidget {
  const ParkingSpotsScreen({super.key});

  @override
  State<ParkingSpotsScreen> createState() => _ParkingSpotsScreenState();
}

class _ParkingSpotsScreenState extends State<ParkingSpotsScreen> {
  List<ParkingSlotModel> parkingSlots = [
    ParkingSlotModel(isBooked: false, time: "", slotId: "", slotName: 'A-1'),
    ParkingSlotModel(isBooked: true, time: "", slotId: "", slotName: 'A-2'),
    ParkingSlotModel(isBooked: false, time: "", slotId: "", slotName: 'A-3'),
    ParkingSlotModel(isBooked: false, time: "", slotId: "", slotName: 'A-4'),
    ParkingSlotModel(isBooked: false, time: "", slotId: "", slotName: 'A-5'),
    ParkingSlotModel(isBooked: true, time: "", slotId: "", slotName: 'A-6'),
    ParkingSlotModel(isBooked: false, time: "", slotId: "", slotName: 'A-7'),
    ParkingSlotModel(isBooked: false, time: "", slotId: "", slotName: 'A-8'),
  ];

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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                        Text("↓ ENTRANCE ↓")
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                for (int i = 0; i < parkingSlots.length; i += 2)
                  Row(
                    children: [
                      Expanded(
                        child: ParkingSlotWidget(parkingSlot: parkingSlots[i]),
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
                          child: ParkingSlotWidget(parkingSlot: parkingSlots[i + 1]),
                        ),
                      ]
                    ],
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
