import 'package:flutter/material.dart';

class ReviewPromoBanners extends StatelessWidget {
  final bool isContributed;
  final ValueChanged<bool> onContributedChanged;

  const ReviewPromoBanners({
    super.key,
    required this.isContributed,
    required this.onContributedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 goTribe Section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Text(
                      'goTribe',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complete this booking* and unlock goTribe1',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Use additional benefits on your next bookings.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_circle_right_outlined,
                      color: Colors.orange),
                ],
              ),
            ],
          ),
        ),

        // 🔹 Donation Section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tap to contribute ₹10 towards\nplantation of two million trees',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onContributedChanged(!isContributed),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isContributed
                            ? const Color(0xFFC8E6C9)
                            : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: isContributed
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                width: 31,
                                height: 31,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(isContributed ? '😊' : '☹️',
                                      style: const TextStyle(fontSize: 18)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Know More',
                style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
