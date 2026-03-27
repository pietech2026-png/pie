import 'package:flutter/material.dart';

class HotelLocationSection extends StatelessWidget {
  final String realAddress;

  const HotelLocationSection({
    super.key,
    required this.realAddress,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Location",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Street View...")));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: const [
                      Text("Street View ", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600)),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(text: "Rated "),
                TextSpan(text: "4.1", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                TextSpan(text: " by guests"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Map Image Mock
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Fullscreen Map...")));
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "lib/assets/bg_image.jpeg", // Placeholder for map
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: const Icon(Icons.fullscreen_exit, color: Colors.blue, size: 20),
                  ),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      realAddress,
                      style: const TextStyle(fontSize: 14, height: 1.3),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copying address...")));
                      },
                      child: const Text("Copy Address", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  const Icon(Icons.directions, color: Colors.blue, size: 28),
                  const Text("Directions", style: TextStyle(color: Colors.blue, fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
