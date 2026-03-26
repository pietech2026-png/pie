import 'package:flutter/material.dart';
import 'room_details_sheet.dart';

class ReviewRoomInfo extends StatelessWidget {
  final Map<String, dynamic> room;
  final String hotelName;
  final int roomCount;
  final int guestCount;

  const ReviewRoomInfo({
    super.key,
    required this.room,
    required this.hotelName,
    required this.roomCount,
    required this.guestCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$roomCount x ${room['type'].toUpperCase()}',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            'Sleeps $guestCount Adults',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildBulletPoint('Room with Breakfast'),
                    _buildBulletPoint('Free Breakfast'),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        RoomDetailsSheet.show(
                          context: context,
                          hotelName: hotelName,
                          room: room,
                          guestCount: guestCount,
                          roomCount: roomCount,
                        );
                      },
                      child: const Text(
                        'View Room & Plan Details',
                        style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  room['image'],
                  width: 100,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
