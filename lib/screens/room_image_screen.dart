// ======================= ROOM IMAGES SCREEN =======================

import 'package:flutter/material.dart';

class RoomImagesScreen extends StatelessWidget {
  final String hotelName;
  final String roomType;
  final List<String> images;
  final int guestCount;
  final int roomCount;
  final int price;
  final int taxes;

  const RoomImagesScreen({
    super.key,
    required this.hotelName,
    required this.roomType,
    required this.images,
    required this.guestCount,
    required this.roomCount,
    required this.price,
    required this.taxes,
  });

  String _formatPrice(int price) {
    if (price >= 1000) {
      final String s = price.toString();
      if (s.length > 3) {
        return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
      }
    }
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roomType,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              hotelName,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              images[index],
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 220,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.hotel,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),

      // ================= BOTTOM BAR =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: const Color(0xFFF5F5F5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '$roomCount Room${roomCount > 1 ? 's' : ''} – Fits $guestCount Adult${guestCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${_formatPrice((price * 1.2).round())}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                        Row(
                          children: const [
                            Icon(Icons.local_offer_outlined,
                                size: 13, color: Color(0xFF1565C0)),
                            SizedBox(width: 4),
                            Text(
                              '2 Offers Applied',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_up,
                                size: 16, color: Color(0xFF1565C0)),
                          ],
                        ),

                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '₹${_formatPrice(price)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' per night',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          '+₹${_formatPrice(taxes)} taxes & fees',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to booking...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8520A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}