import 'package:flutter/material.dart';
import '../screens/room_image_screen.dart';
import 'spec_row.dart';

class RoomDetailsSheet extends StatefulWidget {
  final String hotelName;
  final Map<String, dynamic> room;
  final int guestCount;
  final int roomCount;

  const RoomDetailsSheet({
    super.key,
    required this.hotelName,
    required this.room,
    required this.guestCount,
    required this.roomCount,
  });

  static void show({
    required BuildContext context,
    required String hotelName,
    required Map<String, dynamic> room,
    required int guestCount,
    required int roomCount,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RoomDetailsSheet(
        hotelName: hotelName,
        room: room,
        guestCount: guestCount,
        roomCount: roomCount,
      ),
    );
  }

  @override
  State<RoomDetailsSheet> createState() => _RoomDetailsSheetState();
}

class _RoomDetailsSheetState extends State<RoomDetailsSheet> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final int imgCount = widget.room['imageCount'] as int? ?? 5;
    final List<String> images = List.generate(
      imgCount,
      (_) => widget.room['image'],
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // 🔹 Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Room Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.hotelName,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // 🔹 Room Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.room['type'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 12),

                        // 🔹 Image Carousel
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: 180,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RoomImagesScreen(
                                        hotelName: widget.hotelName,
                                        roomType: widget.room['type'],
                                        images: images,
                                        guestCount: widget.guestCount,
                                        roomCount: widget.roomCount,
                                        price: widget.room['pricePerNight'],
                                        taxes: widget.room['taxes'],
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: PageView.builder(
                                    onPageChanged: (index) {
                                      setState(() => currentPage = index);
                                    },
                                    itemCount: images.length,
                                    itemBuilder: (_, index) {
                                      return Image.asset(
                                        images[index],
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // 🔹 Dots Indicator
                            Positioned(
                              bottom: 10,
                              child: Row(
                                children: List.generate(images.length, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: currentPage == index
                                          ? const Color(0xFFE8520A)
                                          : Colors.white54,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Specs Grid
                        Row(
                          children: [
                            Expanded(
                              child: SpecRow(
                                icon: Icons.square_foot_rounded,
                                label: widget.room['sqft'],
                              ),
                            ),
                            Expanded(
                              child: SpecRow(
                                icon: Icons.bed_outlined,
                                label: widget.room['bedType'],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: SpecRow(
                                icon: Icons.bathtub_outlined,
                                label: widget.room['bathrooms'],
                              ),
                            ),
                            const Expanded(
                              child: SpecRow(
                                icon: Icons.window_outlined,
                                label: 'City View',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Amenities Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amenities',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'Popular with Guests',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        ...(widget.room['benefits'] as List)
                            .map<Widget>((b) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.circle, size: 6),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(b)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
