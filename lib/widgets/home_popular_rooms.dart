import 'package:flutter/material.dart';
import '../screens/select_room.dart';

class HomePopularRooms extends StatelessWidget {
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;
  final int children;

  const HomePopularRooms({
    super.key,
    required this.selectedDates,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Map<String, String>> popularRooms = [
      {
        "name": "Premium Deluxe Room",
        "image": "lib/assets/bg_image.jpeg",
      },
      {
        "name": "Luxury Suite",
        "image": "lib/assets/bg_image.jpeg",
      },
      {
        "name": "Standard Twin Room",
        "image": "lib/assets/bg_image.jpeg",
      },
      {
        "name": "Executive Club Room",
        "image": "lib/assets/bg_image.jpeg",
      },
      {
        "name": "Family Studio",
        "image": "lib/assets/bg_image.jpeg",
      },
    ];

    return SizedBox(
      height: size.height * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularRooms.length,
        itemBuilder: (context, index) {
          final room = popularRooms[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectRoomScreen(
                    hotelName: room["name"]!,
                    selectedDates: selectedDates,
                    guests: adults + children,
                    rooms: rooms,
                  ),
                ),
              );
            },
            child: Container(
              width: size.width * 0.6,
              margin: EdgeInsets.only(right: size.width * 0.04),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      room["image"]!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        room["name"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
