import 'package:flutter/material.dart';

class RoomTypesSheet {
  static void show({
    required BuildContext context,
    required List<Map<String, dynamic>> rooms,
    required Function(int index) onRoomSelected,
    required String Function(int price) formatPrice,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              '${rooms.length} Room Types',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // LIST
            ...rooms.asMap().entries.map((entry) {
              final idx = entry.key;
              final room = entry.value;
              final isLast = idx == rooms.length - 1;

              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.pop(ctx);
                      onRoomSelected(idx); // 🔥 CALLBACK
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room['type'] as String,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${room['bedType']} | ${room['sqft']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // RIGHT
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'starts at',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                '₹${formatPrice(room['pricePerNight'] as int)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}