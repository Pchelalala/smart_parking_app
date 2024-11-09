import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FloorSelector extends StatefulWidget {
  const FloorSelector({super.key});

  @override
  _FloorSelectorState createState() => _FloorSelectorState();
}

class _FloorSelectorState extends State<FloorSelector> {
  String selectedFloor = "1st Floor"; // default value

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      focusColor: Colors.white,
      value: selectedFloor,
      items: const [
        DropdownMenuItem(
          value: "1st Floor",
          child: Text("1st Floor"),
        ),
        DropdownMenuItem(
          value: "2nd Floor",
          child: Text("2nd Floor"),
        ),
        DropdownMenuItem(
          value: "3rd Floor",
          child: Text("3rd Floor"),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedFloor = value ?? "1st Floor";
        });
        if (kDebugMode) {
          print(selectedFloor);
        }
      },
      hint: Text(
        selectedFloor,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 15,
        ),
      ),
    );
  }
}
