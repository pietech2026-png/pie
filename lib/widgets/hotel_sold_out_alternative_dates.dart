import 'package:flutter/material.dart';

class HotelSoldOutAlternativeDates extends StatelessWidget {
  const HotelSoldOutAlternativeDates({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _dateCard("Mar 29 - 30", "₹9,000"),
          const SizedBox(width: 12),
          _dateCard("Mar 28 - 29", "₹9,000"),
          const SizedBox(width: 12),
          _dateCard("Mar 27 - 28", "₹9,000"),
        ],
      ),
    );
  }

  Widget _dateCard(String dateRange, String price) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade800, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateRange,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xDE000000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "from $price",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
