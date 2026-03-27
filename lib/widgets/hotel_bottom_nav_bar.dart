import 'package:flutter/material.dart';
import '../screens/select_room.dart';

class HotelBottomNavBar extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;

  const HotelBottomNavBar({
    super.key,
    required this.hotel,
    required this.selectedDates,
    required this.rooms,
    required this.adults,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "1 Room - Fits N Adults" label
              Text(
                "$rooms Room - Fits $adults Adults",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Strikethrough + offers row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "₹6,390",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.black45,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.local_offer_outlined,
                                size: 13, color: Color(0xFF1565C0)),
                            const SizedBox(width: 3),
                            const Text(
                              "2 Offers Applied",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_up,
                                size: 16, color: Color(0xFF1565C0)),
                          ],
                        ),
                        // Bold price
                        const Text(
                          "₹2,167",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Taxes
                        const Text(
                          "+₹435 taxes & fees",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Orange Select Room button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8520A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelectRoomScreen(
                            hotelName: hotel["name"] as String,
                            selectedDates: selectedDates,
                            guests: adults,
                            rooms: rooms,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Select Room",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
