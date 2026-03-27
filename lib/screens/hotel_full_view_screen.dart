import 'package:flutter/material.dart';
import 'package:pie/services/location_service.dart';
import '../widgets/hotel_bottom_nav_bar.dart';
import '../widgets/hotel_image_section.dart';
import '../widgets/hotel_details_header.dart';
import '../widgets/hotel_date_bar.dart';
import '../widgets/hotel_coupons_section.dart';
import '../widgets/hotel_about_section.dart';
import '../widgets/hotel_amenities_section.dart';
import '../widgets/hotel_rules_section.dart';
import '../widgets/hotel_reviews_section.dart';
import '../widgets/hotel_location_section.dart';

// Import Sold Out Widgets (to be created)
import '../widgets/hotel_sold_out_banner.dart';
import '../widgets/hotel_sold_out_alternative_dates.dart';
import '../widgets/similar_hotels_section.dart';

class HotelFullViewScreen extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;
  final bool isSoldOut; // Added for Sold Out UI demonstration

  const HotelFullViewScreen({
    super.key,
    required this.hotel,
    required this.selectedDates,
    this.rooms = 1,
    this.adults = 2,
    this.isSoldOut = false, // Default to not sold out
  });

  @override
  State<HotelFullViewScreen> createState() => _HotelFullViewScreenState();
}

class _HotelFullViewScreenState extends State<HotelFullViewScreen> {
  late DateTimeRange selectedDates;
  int currentIndex = 0;
  String _realAddress = "Fetching real location...";

  @override
  void initState() {
    super.initState();
    selectedDates = widget.selectedDates;
    _fetchRealLocation();
  }

  Future<void> _fetchRealLocation() async {
    try {
      final query = (widget.hotel["location"] as String).split("|").first.trim();
      final results = await LocationService.searchLocation(query);
      if (mounted) {
        setState(() {
          if (results.isNotEmpty && results.first['display_name'] != null) {
            _realAddress = results.first['display_name'];
          } else {
            _realAddress = widget.hotel["location"] ?? "Unknown Location";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _realAddress = widget.hotel["location"] ?? "Unknown Location";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images =
        (widget.hotel["images"] as List?)?.cast<String>() ??
            [widget.hotel["image"] as String];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      
      // Pass the state to BottomNavBar
      bottomNavigationBar: widget.isSoldOut 
        ? null // No regular bottom bar if sold out? Or maybe a "View Similar" button?
        : HotelBottomNavBar(
            hotel: widget.hotel,
            selectedDates: selectedDates,
            rooms: widget.rooms,
            adults: widget.adults,
          ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            HotelImageSection(
              images: images,
              currentIndex: currentIndex,
              onPageChanged: (i) => setState(() => currentIndex = i),
              onBack: () => Navigator.pop(context, selectedDates),
            ),

            // SOLD OUT BANNER (New)
            if (widget.isSoldOut)
              HotelSoldOutBanner(selectedDates: selectedDates),

            // DETAILS HEADER
            HotelDetailsHeader(hotel: widget.hotel),

            const SizedBox(height: 15),

            // DATE BAR
            HotelDateBar(
              selectedDates: selectedDates,
              onDatesChanged: (newDates) => setState(() => selectedDates = newDates),
            ),

            const SizedBox(height: 15),

            // ALTERNATIVE DATES (New - only if sold out)
            if (widget.isSoldOut) ...[
              const HotelSoldOutAlternativeDates(),
              const SizedBox(height: 20),
            ],

            // COUPONS (Hide if sold out?)
            if (!widget.isSoldOut) ...[
              const HotelCouponsSection(),
              const SizedBox(height: 20),
            ],

            // ABOUT SECTION
            const HotelAboutSection(),

            const SizedBox(height: 20),

            // AMENITIES SECTION
            const HotelAmenitiesSection(),

            const SizedBox(height: 20),

            // RULES SECTION
            const HotelRulesSection(),

            const SizedBox(height: 20),

            // REVIEWS SECTION
            const HotelReviewsSection(),

            const SizedBox(height: 20),

            // LOCATION SECTION
            HotelLocationSection(realAddress: _realAddress),
            
            // SIMILAR PROPERTIES (New - if sold out)
            if (widget.isSoldOut) ...[
              const SizedBox(height: 20),
              const SimilarHotelsSection(),
            ],
          ],
        ),
      ),
    );
  }
}