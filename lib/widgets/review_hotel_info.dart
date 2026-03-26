import 'package:flutter/material.dart';

class ReviewHotelInfo extends StatelessWidget {
  final String hotelName;
  final String checkInStr;
  final String checkOutStr;
  final int nights;
  final int roomCount;
  final int guestCount;
  final String imagePath;

  const ReviewHotelInfo({
    super.key,
    required this.hotelName,
    required this.checkInStr,
    required this.checkOutStr,
    required this.nights,
    required this.roomCount,
    required this.guestCount,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Hotel Info Section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('3 ', style: TextStyle(fontSize: 10)),
                          Icon(Icons.star, size: 10, color: Colors.orange),
                          Text(' • Hotel', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hotelName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Shavri Colony, Udaipur',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '4.6/5',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '144 ratings and 53 reviews',
                          style:
                              TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 🔹 Check-in Check-out Section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checkInStr,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Text('12 PM',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$nights Night${nights > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    checkOutStr,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Text('10 AM',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),

        // 🔹 Occupancy Section
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            '$roomCount Rooms, $guestCount Adults',
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
