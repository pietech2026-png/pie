import 'package:flutter/material.dart';

class ElitePackageBanner extends StatelessWidget {
  final int savings;
  final int price;

  const ElitePackageBanner({
    super.key,
    required this.savings,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E0),
        border: Border.all(color: const Color(0xFFD4A017)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD4A017)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Elite Package',
                  style: TextStyle(
                    color: Color(0xFFB8860B),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87),
              children: [
                const TextSpan(text: 'Enjoy benefits worth '),
                TextSpan(
                  text: '₹$savings',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const TextSpan(text: ' at just '),
                TextSpan(
                  text: '₹$price only',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}