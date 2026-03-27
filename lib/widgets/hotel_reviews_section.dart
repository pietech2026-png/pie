import 'package:flutter/material.dart';
import '../screens/hotel_reviews_screen.dart';

class HotelReviewsSection extends StatelessWidget {
  const HotelReviewsSection({super.key});

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
          const Text("Review & Rating",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("3.9/5",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: const [
                    _ratingBar("5", 110),
                    _ratingBar("4", 32),
                    _ratingBar("3", 32),
                    _ratingBar("2", 8),
                    _ratingBar("1", 23),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text("205 Ratings • 44 Reviews",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          const Text("👍 3.6 Average rating since last 6 months",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          const Text("Rating Score Card",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _scoreCard("4.0", "Food"),
              _scoreCard("4.9", "Cleanliness"),
              _scoreCard("4.0", "Value For Money"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Text("Reviews Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text("new",
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          const Text("Powered by Gia.AI",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          const Text(
            "Guests appreciate the clean, hygienic environment and the friendly, helpful staff. "
                "The property is well-located and offers decent amenities. "
                "Overall experiences have been positive with many recommending the property.",
          ),
          const SizedBox(height: 10),
          const Text(
            "Bathroom Review: Clean, running water available. Smelled fresh and pleasant. No bugs or pests.",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Did you find Review Summary useful?"),
              Row(
                children: const [
                  Icon(Icons.thumb_up_alt_outlined, size: 20),
                  SizedBox(width: 12),
                  Icon(Icons.thumb_down_alt_outlined, size: 20),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          const Text("Guest Reviews",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // REVIEW CARD
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Very good service, good reception staff, good room service.",
                      ),
                      SizedBox(height: 8),
                      Text("- Nitin Sonker",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("5/5",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showReviewsPopup(context),
            child: const Text("View all 44 Reviews",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showReviewsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const HotelReviewsPopup(),
    );
  }
}

class _ratingBar extends StatelessWidget {
  final String label;
  final double value;
  const _ratingBar(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 150,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _scoreCard extends StatelessWidget {
  final String score;
  final String label;
  const _scoreCard(this.score, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(score,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
