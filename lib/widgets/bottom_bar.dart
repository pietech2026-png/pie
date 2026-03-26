import 'package:flutter/material.dart';
import 'package:pie/screens/continue_screen.dart';
import 'offers_applied_sheet.dart';

Widget buildBottomBar({
  required BuildContext context,
  required int price,
  required int taxes,
  required Map<String, dynamic> room,
  required int guestCount,
  required int roomCount,
  required String Function(int) formatPrice,
  required DateTimeRange selectedDates,
  required String hotelName,
  String buttonText = 'Continue',
  VoidCallback? onPressed,
  int addonPrice = 0,
  int totalSavings = 0,
  int priceAfterDiscount = 0,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 10,
          offset: Offset(0, -3),
        )
      ],
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  room['image'] as String,
                  width: 44,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44,
                    height: 38,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.hotel,
                        size: 20, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room['type'] as String,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 13, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(
                          '$guestCount Adult${guestCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: const Color(0xFFF5F5F5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '$roomCount Room${roomCount > 1 ? 's' : ''} – Fits $guestCount Adult${guestCount > 1 ? 's' : ''}',
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54),
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
                      '₹${formatPrice((price * 1.2).round())}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => OffersAppliedSheet.show(
                        context,
                        totalSavings: totalSavings,
                        priceAfterDiscount: priceAfterDiscount,
                        roomCount: roomCount,
                        nights: selectedDates.duration.inDays,
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.local_offer_outlined,
                              size: 13, color: Color(0xFF1565C0)),
                          SizedBox(width: 4),
                          Text(
                            '2 Offers Applied',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.keyboard_arrow_up,
                              size: 16, color: Color(0xFF1565C0)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '₹${formatPrice(price * (selectedDates.duration.inDays * roomCount) + taxes + addonPrice)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' total',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'for ${selectedDates.duration.inDays * roomCount} Room${selectedDates.duration.inDays * roomCount > 1 ? 's' : ''} ${selectedDates.duration.inDays} Night${selectedDates.duration.inDays > 1 ? 's' : ''}${addonPrice > 0 ? ' + Addon' : ''}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      'Incl. of ₹${formatPrice(taxes)} taxes & fees',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onPressed ?? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContinueScreen(
                        hotelName: hotelName,
                        selectedDates: selectedDates,
                        guestCount: guestCount,
                        roomCount: roomCount,
                        room: room,
                        price: price,
                        taxes: taxes,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8520A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}