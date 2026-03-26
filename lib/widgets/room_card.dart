import 'package:flutter/material.dart';
import 'elite_banner.dart';

class RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;
  final int index;
  final bool isSelected;
  final bool isExpanded;
  final Size size;
  final GlobalKey keyValue;

  final VoidCallback onToggleExpand;
  final VoidCallback onSelect;
  final VoidCallback onRoomDetailsTap;

  final Widget planCard;

  const RoomCard({
    super.key,
    required this.room,
    required this.index,
    required this.isSelected,
    required this.isExpanded,
    required this.size,
    required this.keyValue,
    required this.onToggleExpand,
    required this.onSelect,
    required this.onRoomDetailsTap,
    required this.planCard,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasElite = room['elitePackage'] as bool;

    return AnimatedContainer(
      key: keyValue,
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isSelected
            ? Border.all(color: const Color(0xFF1565C0), width: 2)
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasElite)
            ElitePackageBanner(
              savings: room['eliteSavings'] as int,
              price: room['elitePrice'] as int,
            ),

          GestureDetector(
            onTap: onToggleExpand,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      room['type'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.0 : -0.5,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16, bottom: 12),
                  child: Text(
                    'Max ${room['maxGuests']} Guests',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10),
                            child: Image.asset(
                              room['image'] as String,
                              width: size.width * 0.34,
                              height: size.width * 0.28,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  const Icon(
                                      Icons
                                          .photo_library_outlined,
                                      color: Colors.white,
                                      size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room['imageCount']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _specRow(Icons.square_foot_rounded,
                                room['sqft']),
                            const SizedBox(height: 8),
                            _specRow(Icons.bed_outlined,
                                room['bedType']),
                            const SizedBox(height: 8),
                            _specRow(Icons.bathtub_outlined,
                                room['bathrooms']),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: onRoomDetailsTap,
                              child: const Text(
                                'Room Details',
                                style: TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 13,
                                  decoration:
                                  TextDecoration
                                      .underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                planCard,
              ],
            ),
            secondChild:
            const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _specRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87)),
        ),
      ],
    );
  }
}