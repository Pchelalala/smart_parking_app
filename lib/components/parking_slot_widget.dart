import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:flutter/material.dart';

import '../screens/booking_screen.dart';
import '../models/parking_slot_model.dart';

class ParkingSlotWidget extends StatelessWidget {
  final ParkingSlotModel parkingSlot;

  const ParkingSlotWidget({
    super.key,
    required this.parkingSlot,
  });

  @override
  Widget build(BuildContext context) {
    return DashedContainer(
      dashColor: Colors.blue.shade300,
      dashedLength: 10.0,
      blankLength: 9.0,
      strokeWidth: 1.0,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 180,
        height: 140,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    parkingSlot.slotName,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
            if (parkingSlot.isBooked)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/car.png"),
                    const SizedBox(height: 1),
                    Text(
                      "BOOKED",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BookingPage(
                          slotName: parkingSlot.slotName,
                        ),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "BOOK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
