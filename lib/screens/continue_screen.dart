import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/review_hotel_info.dart';
import '../widgets/review_room_info.dart';
import '../widgets/review_promo_banners.dart';
import '../widgets/review_price_summary.dart';
import '../widgets/review_addons_section.dart';
import '../widgets/review_offers_section.dart';
import '../widgets/offers_applied_sheet.dart';
import '../widgets/review_rules_section.dart';
import '../widgets/review_promo_code.dart';
import '../widgets/review_traveller_details.dart';

class ContinueScreen extends StatefulWidget {
  final String hotelName;
  final DateTimeRange selectedDates;
  final int guestCount;
  final int roomCount;
  final Map<String, dynamic> room;
  final int price;
  final int taxes;

  const ContinueScreen({
    super.key,
    required this.hotelName,
    required this.selectedDates,
    required this.guestCount,
    required this.roomCount,
    required this.room,
    required this.price,
    required this.taxes,
  });

  @override
  State<ContinueScreen> createState() => _ContinueScreenState();
}

class _ContinueScreenState extends State<ContinueScreen> {
  bool isLoginToggled = false;
  bool isBreakfastAdded = false;

  Map<String, bool> selectedAddons = {
    'luggage': false,
    'carModel': false,
    'pet': false,
    'refundable': false,
  };

  final Map<String, int> addonPrices = {
    'breakfast': 801,
    'luggage': 1001,
    'carModel': 751,
    'pet': 1001,
    'refundable': 751,
  };

  final Map<String, String> addonNames = {
    'breakfast': 'Breakfast',
    'luggage': 'Luggage Space',
    'carModel': 'Car Model Upgrade',
    'pet': 'Pet Allowance',
    'refundable': 'Refundable Upgrade',
  };

  int get totalAddonPrice {
    int total = isBreakfastAdded ? addonPrices['breakfast']! : 0;
    selectedAddons.forEach((key, value) {
      if (value) total += addonPrices[key]!;
    });
    return total;
  }

  List<Map<String, dynamic>> get appliedAddonsList {
    List<Map<String, dynamic>> list = [];
    if (isBreakfastAdded) {
      list.add({'name': addonNames['breakfast'], 'price': addonPrices['breakfast']});
    }
    selectedAddons.forEach((key, value) {
      if (value) {
        list.add({'name': addonNames[key], 'price': addonPrices[key]});
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d MMM, EEE');
    final String checkInStr = formatter.format(widget.selectedDates.start);
    final String checkOutStr = formatter.format(widget.selectedDates.end);
    final int nights = widget.selectedDates.duration.inDays;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Booking',
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${formatter.format(widget.selectedDates.start)} - ${formatter.format(widget.selectedDates.end)}, ${widget.roomCount} Rooms, ${widget.guestCount} Guests',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E2EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: isLoginToggled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 26,
                        height: 26,
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLoginToggled ? Icons.person : Icons.lock_outline,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReviewHotelInfo(
              hotelName: widget.hotelName,
              checkInStr: checkInStr,
              checkOutStr: checkOutStr,
              nights: nights,
              roomCount: widget.roomCount,
              guestCount: widget.guestCount,
              imagePath: widget.room['image'],
            ),
            ReviewRoomInfo(
              room: widget.room,
              hotelName: widget.hotelName,
              roomCount: widget.roomCount,
              guestCount: widget.guestCount,
            ),
            const ReviewRulesSection(),
            const SizedBox(height: 12),
            const ReviewPromoBanners(),
            const SizedBox(height: 12),
            ReviewPriceSummary(
              price: widget.price,
              taxes: widget.taxes,
              addonPrice: totalAddonPrice,
              appliedAddons: appliedAddonsList,
              formatPrice: _formatPrice,
            ),
            const SizedBox(height: 12),
            ReviewAddonsSection(
              isBreakfastAdded: isBreakfastAdded,
              onBreakfastToggle: () {
                setState(() {
                  isBreakfastAdded = !isBreakfastAdded;
                });
              },
              additionalAddons: selectedAddons,
              onAddonToggle: (key, value) {
                setState(() {
                  selectedAddons[key] = value;
                });
              },
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => OffersAppliedSheet.show(
                context,
                totalSavings: 4562,
                priceAfterDiscount: 2438,
                roomCount: widget.roomCount,
                nights: nights,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '2 offers applied',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                    Text(
                      'VIEW',
                      style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const ReviewOffersSection(),
            const SizedBox(height: 12),
            const ReviewPromoCode(),
            const SizedBox(height: 12),
            const ReviewTravellerDetails(),
            const SizedBox(height: 100), // Spacing for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(
        context: context,
        price: widget.price,
        taxes: widget.taxes,
        room: widget.room,
        guestCount: widget.guestCount,
        roomCount: widget.roomCount,
        formatPrice: _formatPrice,
        selectedDates: widget.selectedDates,
        hotelName: widget.hotelName,
        addonPrice: totalAddonPrice,
        totalSavings: 4562,
        priceAfterDiscount: 2438,
        buttonText: 'Confirm\nTraveller Details',
        onPressed: () {
          // Placeholder for final confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking Confirmed!')),
          );
        },
      ),
    );
  }

  String _formatPrice(int price) {
    return NumberFormat('#,##,###').format(price);
  }
}
