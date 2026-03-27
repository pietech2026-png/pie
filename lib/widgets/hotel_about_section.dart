import 'package:flutter/material.dart';

class HotelAboutSection extends StatelessWidget {
  const HotelAboutSection({super.key});

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
          const Text("About the Hotel",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "A premium property in New Delhi offering numerous dining options and a rooftop swimming pool.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _aboutItem(Icons.location_on,
              "The property is nestled in I.P. Extension, close to the Akshardham Temple and India Gate."),
          _aboutItem(Icons.bed,
              "Deluxe Room offers stunning views of the city making your stay scenic and memorable."),
          _aboutItem(Icons.restaurant,
              "Experience mouth-watering multi-cuisines at RBG Bar and Grill."),
        ],
      ),
    );
  }

  Widget _aboutItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
