import 'package:flutter/material.dart';

class HotelDetailsHeader extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const HotelDetailsHeader({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("4 ⭐ • Hotel",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            hotel["name"] as String,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("3.9/5",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              const Text("205 ratings and 44 reviews"),
            ],
          ),
        ],
      ),
    );
  }
}
