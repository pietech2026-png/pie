import 'package:flutter/material.dart';

class HotelAmenitiesSection extends StatelessWidget {
  const HotelAmenitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Amenities",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _amenity("Gym")),
            Expanded(child: _amenity("Restaurant")),
          ]),
          Row(children: [
            Expanded(child: _amenity("Lounge")),
            Expanded(child: _amenity("Bar")),
          ]),
          Row(children: [
            Expanded(child: _amenity("Housekeeping")),
            Expanded(child: _amenity("Wi-Fi")),
          ]),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showAmenitiesPopup(context),
            child: const Text("View All Amenities",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _amenity(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showAmenitiesPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("All Amenities",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 15,
              children: [
                _amenity("Swimming Pool"),
                _amenity("Spa"),
                _amenity("Room Service"),
                _amenity("Parking"),
                _amenity("Bar"),
                _amenity("Gym"),
                _amenity("Wi-Fi"),
                _amenity("Restaurant"),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
