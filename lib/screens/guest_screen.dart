import 'package:flutter/material.dart';

class GuestScreen extends StatefulWidget {
  final int rooms;
  final int adults;
  final int children;

  const GuestScreen({
    super.key,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  late int rooms;
  late int adults;
  late int children;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize with values from HomeScreen
    rooms = widget.rooms;
    adults = widget.adults;
    children = widget.children;
  }

  Widget counter(String title, int value, Function(bool) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => onChange(false),
                icon: const Icon(Icons.remove),
              ),
              Text(
                value.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: () => onChange(true),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Guests"),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          children: [

            // Rooms
            counter("Rooms", rooms, (isAdd) {
              setState(() {
                if (isAdd) {
                  rooms++;
                } else if (rooms > 1) {
                  rooms--;
                }
              });
            }),

            // Adults
            counter("Adults", adults, (isAdd) {
              setState(() {
                if (isAdd) {
                  adults++;
                } else if (adults > 1) {
                  adults--;
                }
              });
            }),

            // Children
            counter("Children", children, (isAdd) {
              setState(() {
                if (isAdd) {
                  children++;
                } else if (children > 0) {
                  children--;
                }
              });
            }),

            const Spacer(),

            // ✅ DONE BUTTON RETURNS DATA
            SizedBox(
              width: double.infinity,
              height: size.height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    "rooms": rooms,
                    "adults": adults,
                    "children": children,
                  });
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}