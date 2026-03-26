// ======================= HOTEL FULL VIEW SCREEN =======================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie/services/location_service.dart';
import 'calendar_screen.dart';
import 'hotel_reviews_screen.dart';
import 'select_room.dart';

class HotelFullViewScreen extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;

  const HotelFullViewScreen({
    super.key,
    required this.hotel,
    required this.selectedDates,
    this.rooms = 1,
    this.adults = 2,
  });

  @override
  State<HotelFullViewScreen> createState() =>
      _HotelFullViewScreenState();
}

class _HotelFullViewScreenState extends State<HotelFullViewScreen> {
  late DateTimeRange selectedDates;
  int currentIndex = 0;
  String _selectedLocationChip = "Key Landmarks";
  String _realAddress = "Fetching real location...";
  Map<String, bool> _copiedCoupons = {};

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
            _realAddress = results.first[ 'display_name'];
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
    final size = MediaQuery.of(context).size;

    final List<String> images =
        (widget.hotel["images"] as List?)?.cast<String>() ??
            [widget.hotel["image"] as String];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ── BOTTOM NAV BAR ─────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "1 Room - Fits N Adults" label
                Text(
                  "${widget.rooms} Room - Fits ${widget.adults} Adults",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Strikethrough + offers row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "₹6,390",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.black45,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.local_offer_outlined,
                                  size: 13, color: Color(0xFF1565C0)),
                              const SizedBox(width: 3),
                              const Text(
                                "2 Offers Applied",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_up,
                                  size: 16, color: Color(0xFF1565C0)),
                            ],
                          ),
                          // Bold price
                          const Text(
                            "₹2,167",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          // Taxes
                          const Text(
                            "+₹435 taxes & fees",
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Orange Select Room button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8520A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelectRoomScreen(
                              hotelName: widget.hotel["name"] as String,
                              selectedDates: selectedDates,
                              guests: widget.adults,
                              rooms: widget.rooms,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Select Room",
                        style: TextStyle(
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
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  height: size.height * 0.32,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (i) =>
                          setState(() => currentIndex = i),
                      itemBuilder: (_, i) => Image.asset(
                        images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () =>
                          Navigator.pop(context, selectedDates),
                    ),
                  ),
                ),

                const Positioned(
                  top: 40,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.share),
                  ),
                ),
              ],
            ),

            // DETAILS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("4 ⭐ • Hotel",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 6),

                  Text(
                    widget.hotel["name"] as String,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("3.9/5",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text("205 ratings and 44 reviews"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // DATE BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${selectedDates.start.day} Mar - ${selectedDates.end.day} Mar | 2 Guests"),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CalendarScreen(initialDates: selectedDates),
                        ),
                      );

                      if (result != null) {
                        setState(() => selectedDates = result);
                      }
                    },
                    child: const Text("Edit",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // COUPONS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Coupons",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _couponCard(
                    brandName: "Uber",
                    brandIcon: Icons.local_taxi,
                    description: "20% flat off on all rides within the city using Credit Card",
                    code: "STEALDEAL20",
                    validTill: "20 Dec, 2025",
                    gradientColors: [const Color(0xFF9B59B6), const Color(0xFF6C3483)],
                  ),
                  const SizedBox(width: 12),
                  _couponCard(
                    brandName: "Zomato",
                    brandIcon: Icons.restaurant,
                    description: "Flat ₹150 off on your first order above ₹299",
                    code: "HOTELDEAL15",
                    validTill: "31 Mar, 2025",
                    gradientColors: [const Color(0xFFE74C3C), const Color(0xFFC0392B)],
                  ),
                  const SizedBox(width: 12),
                  _couponCard(
                    brandName: "HSBC Bank",
                    brandIcon: Icons.credit_card,
                    description: "Get ₹1139 off on payment via HSBC Credit Card EMI",
                    code: "HSBCEMI20",
                    validTill: "30 Apr, 2025",
                    gradientColors: [const Color(0xFF2980B9), const Color(0xFF1A5276)],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= ABOUT HOTEL =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("About the Hotel",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    "A premium property in New Delhi offering numerous dining options and a rooftop swimming pool.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  _aboutItem(Icons.location_on,
                      "The property is nestled in I.P. Extension, close to the Akshardham Temple and India Gate."),
                  _aboutItem(Icons.bed,
                      "Deluxe Room offers stunning views of the city making your stay scenic and memorable."),
                  _aboutItem(Icons.restaurant,
                      "Experience mouth-watering multi-cuisines at RBG Bar and Grill."),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= AMENITIES =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Amenities",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _amenity("Gym")),
                    Expanded(child: _amenity("Restaurant")),
                  ]),
                  Row(children: [
                    Expanded(child: _amenity("Lounge")),
                    Expanded(child: _amenity("Bar")),
                  ]),
                  Row(children: [
                    Expanded(child: _amenity("Housekeeping")),
                    Expanded(child: _amenity("Wi-Fi")),
                  ]),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _showAmenitiesPopup,
                    child: const Text("View All Amenities",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= HOTEL RULES =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Hotel Rules",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  const Text(
                    "Check-In: 12 PM | Check-Out: 11 AM",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  _rule("Unmarried couples allowed"),
                  _rule("Primary Guest should be atleast 18 years of age."),
                  _rule(
                      "Aadhaar, Driving License and Passport are accepted as ID proof(s)"),
                  _rule("Pets are not allowed"),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: _showRulesPopup,
                    child: const Text("View all rules and policies",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= REVIEW & RATING =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Review & Rating",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("3.9/5",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          children: const [
                            _ratingBar("5", 110),
                            _ratingBar("4", 32),
                            _ratingBar("3", 32),
                            _ratingBar("2", 8),
                            _ratingBar("1", 23),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text("205 Ratings • 44 Reviews",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 10),

                  const Text("👍 3.6 Average rating since last 6 months",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 15),

                  const Text("Rating Score Card",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _scoreCard("4.0", "Food"),
                      _scoreCard("4.9", "Cleanliness"),
                      _scoreCard("4.0", "Value For Money"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= NEW: REVIEWS SUMMARY =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: const [
                      Text("Reviews Summary",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 6),
                      Text("new",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 4),

                  const Text("Powered by Gia.AI",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 10),

                  const Text(
                    "Guests appreciate the clean, hygienic environment and the friendly, helpful staff. "
                        "The property is well-located and offers decent amenities. "
                        "Overall experiences have been positive with many recommending the property.",
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Bathroom Review: Clean, running water available. Smelled fresh and pleasant. No bugs or pests.",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Did you find Review Summary useful?"),
                      Row(
                        children: const [
                          Icon(Icons.thumb_up_alt_outlined, size: 20),
                          SizedBox(width: 12),
                          Icon(Icons.thumb_down_alt_outlined, size: 20),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text("Guest Reviews",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  // REVIEW CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Very good service, good reception staff, good room service.",
                              ),
                              SizedBox(height: 8),
                              Text("- Nitin Sonker",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("5/5",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: _showReviewsPopup,
                    child: const Text("View all 44 Reviews",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // ================= LOCATION =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Location",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Street View...")));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: const [
                              Text("Street View ", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600)),
                              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(text: "Rated "),
                        TextSpan(text: "4.1", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        TextSpan(text: " by guests"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Map Image Mock
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Fullscreen Map...")));
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "lib/assets/bg_image.jpeg", // Placeholder for map
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            ),
                            child: const Icon(Icons.fullscreen_exit, color: Colors.blue, size: 20),
                          ),
                        ),
                        const Positioned.fill(
                          child: Center(
                            child: Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _realAddress,
                              style: const TextStyle(fontSize: 14, height: 1.3),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Maps App...")));
                              },
                              child: const Text("View on maps", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Chips Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _locationChip(Icons.location_on, "Key Landmarks"),
                        _locationChip(Icons.camera_alt, "Attractions"),
                        _locationChip(Icons.directions_transit, "Transport"),
                        _locationChip(Icons.more_horiz, "Other"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= SIMILAR PROPERTIES =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Similar Properties",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _similarPropertyCard(context, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= POPUPS =================

  void _showAmenitiesPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _popupContainer(
        "Amenities",
        const [
          "Restaurant",
          "Butler Services",
          "Power Backup",
          "Elevator/Lift",
          "Refrigerator",
          "Housekeeping",
          "Wi-Fi",
          "Parking",
          "Air Conditioning",
          "Room Service"
        ],
      ),
    );
  }

  // ======================= COUPON CARD =======================
  Widget _couponCard({
    required String brandName,
    required IconData brandIcon,
    required String description,
    required String code,
    required String validTill,
    required List<Color> gradientColors,
  }) {
    final isCopied = _copiedCoupons[code] ?? false;
    return Container(
      width: 230,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Left notch
          Positioned(
            left: -14,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          
          // Right notch
          Positioned(
            right: -14,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand icon badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(brandIcon, color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(brandName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500, height: 1.3),
                ),
                const SizedBox(height: 8),
                // Code + Copy Button row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          code,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 11),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: code));
                        setState(() => _copiedCoupons[code] = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _copiedCoupons[code] = false);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                        ),
                        child: Text(
                          isCopied ? "COPIED!" : "COPY CODE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: isCopied ? Colors.green : gradientColors.first,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Valid Till
                Text(
                  "Valid Till: $validTill",
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _popupContainer(
        "Hotel Rules",
        const [
          "Unmarried couples allowed",
          "Primary Guest should be atleast 18 years of age",
          "Valid ID proof required",
          "Pets are not allowed",
          "Check-in after 12 PM",
          "Check-out before 11 AM"
        ],
      ),
    );
  }

  void _showReviewsPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const HotelReviewsPopup(),
    );
  }

  Widget _popupContainer(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.check),
                title: Text(items[i]),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= SMALL WIDGETS =================

  Widget _aboutItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _amenity(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.teal, size: 18),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }

  Widget _rule(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.info, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _locationChip(IconData icon, String label) {
    bool isSelected = _selectedLocationChip == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLocationChip = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue.shade50 : Colors.white,
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.blue : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.black87, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _similarPropertyCard(BuildContext context, int index) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 15, bottom: 5, left: 2, top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              "lib/assets/bg_image.jpeg",
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text("4.${5 - index} (12${index} Reviews)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Hotel Premium ${index + 1}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text("₹2,167",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("+ ₹435 taxes & fees",
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 STATIC WIDGETS

class _ratingBar extends StatelessWidget {
  final String star;
  final int count;

  const _ratingBar(this.star, this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$star ★"),
        const SizedBox(width: 5),
        Expanded(
          child: LinearProgressIndicator(
            value: count / 110,
            backgroundColor: Colors.grey,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5),
        Text(count.toString()),
      ],
    );
  }
}

class _scoreCard extends StatelessWidget {
  final String score;
  final String title;

  const _scoreCard(this.score, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(score,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}