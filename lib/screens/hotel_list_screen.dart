import 'package:flutter/material.dart';
import '../widgets/hotel_card.dart';

class HotelListScreen extends StatelessWidget {
  final String location;
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;

  const HotelListScreen({
    super.key,
    required this.location,
    required this.selectedDates,
    this.rooms = 1,
    this.adults = 2,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ SAFE DATA TYPE
    final List<Map<String, dynamic>> hotels =
    List.generate(5, (index) {
      return {
        "name": "Hello By Ananya Puri ${index + 1}",
        "location": "Puri | 5 km drive to Jagannath Temple",
        "price": "1,563",
        "originalPrice": "6,480",
        "rating": "4.3",
        "reviews": "766",
        "image": "lib/assets/bg_image.jpeg",
        "images": [
          "lib/assets/bg_image.jpeg",
          "lib/assets/bg_image.jpeg",
        ],
        "details":
        "Spacious rooms, in-house cafe, free parking, couple friendly & premium stay experience.",
      };
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Showing Properties in $location", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return HotelCard(
            hotel: hotels[index],
            selectedDates: selectedDates,
            rooms: rooms,
            adults: adults,
            index: index,
          );
        },
      ),
    );
  }
}