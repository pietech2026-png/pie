import 'package:flutter/material.dart';

class HotelReviewsPopup extends StatelessWidget {
  const HotelReviewsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Guest Reviews",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Summary Section
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("3.9/5",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Very Good",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("205 Ratings • 44 Reviews",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ratingBarRow("5", 110),
                        _ratingBarRow("4", 32),
                        _ratingBarRow("3", 32),
                        _ratingBarRow("2", 8),
                        _ratingBarRow("1", 23),
                      ],
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  
                  // Reviews List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sampleReviews.length,
                    itemBuilder: (context, index) {
                      final review = sampleReviews[index];
                      final ratingValue = double.parse(review['rating']!);
                      
                      Color badgeColor;
                      Color textColor;
                      if (ratingValue >= 4.0) {
                        badgeColor = Colors.green.shade100;
                        textColor = Colors.green;
                      } else if (ratingValue >= 3.0) {
                        badgeColor = Colors.orange.shade100;
                        textColor = Colors.orange;
                      } else {
                         badgeColor = Colors.red.shade100;
                         textColor = Colors.red;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: badgeColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text("${review['rating']!}/5",
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      review['author']!,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(review['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              review['text']!,
                              style: const TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingBarRow(String star, int count) {
    Color barColor;
    if (star == "5" || star == "4") {
      barColor = Colors.green;
    } else if (star == "3") {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$star ★", style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: count / 110,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(count.toString(), style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

const List<Map<String, String>> sampleReviews = [
  {
    "author": "Nitin Sonker",
    "rating": "5.0",
    "date": "22 Mar 2026",
    "text": "Very good service, good reception staff, good room service. The stay was exceptionally pleasant and the food offered at the restaurant was tasty. I definitely recommend this place for family trips."
  },
  {
    "author": "Rahul Sharma",
    "rating": "4.0",
    "date": "15 Mar 2026",
    "text": "The rooms were clean and the location is great. We had a minor issue with the Wi-Fi on the first day, but the staff fixed it promptly. Overall a good experience."
  },
  {
    "author": "Anjali Gupta",
    "rating": "5.0",
    "date": "10 Mar 2026",
    "text": "Beautiful property with amazing amenities. The rooftop pool was the highlight of our stay. The breakfast buffet had a wide variety of options."
  },
  {
    "author": "Vikram Singh",
    "rating": "3.0",
    "date": "05 Mar 2026",
    "text": "Decent stay. The room was a bit smaller than expected from the pictures. Service was alright but could be faster during peak hours."
  },
  {
    "author": "Sneha Reddy",
    "rating": "4.0",
    "date": "28 Feb 2026",
    "text": "Value for money. The location is perfect, close to all major attractions. The staff was courteous and helped us arrange a cab for sightseeing."
  },
  {
    "author": "Amit Patel",
    "rating": "5.0",
    "date": "20 Feb 2026",
    "text": "Excellent hospitality! The staff went out of their way to make our anniversary special. The room was upgraded for free. Highly recommended!"
  },
];
