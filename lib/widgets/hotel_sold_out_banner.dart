import 'package:flutter/material.dart';

class HotelSoldOutBanner extends StatelessWidget {
  final DateTimeRange selectedDates;

  const HotelSoldOutBanner({
    super.key,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFEBEE), // Very light red
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252), // Material Red
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Soldout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "for these travel dates",
                style: TextStyle(
                  color: Color(0xFFC62828),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Property is available in the following dates",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
